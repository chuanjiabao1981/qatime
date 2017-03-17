module LiveService
  class CourseDirector
    def initialize(course)
      @course = course
    end

    # 初始化辅导班所需实体
    def instance_for_course
      # 初始化直播推拉流
      instance_studio
      teacher = @course.teacher
      teacher_account = teacher.chat_account
      # 检查教师云信ID
      teacher_account ||= instance_account(teacher)
      user_ids = @course.tickets.map(&:student_id)
      members = Chat::Account.where(id: user_ids)
      # 初始化聊天群组
      instance_team_and_members(teacher_account, members)
    end

    # 辅导播放班授权
    def authorize_for_course(lesson)
    end

    # 发放听课证
    def deliver_ticket
    end

    # 辅导班直播流状态查询
    # 心跳时差大于15秒把直播状态设置为未开始
    def stream_status
      time_diff = @course.live_sessions.last.try(:heartbeat_at) && (Time.now - @course.live_sessions.last.try(:heartbeat_at))
      board = time_diff.to_i > 15 ? 0 : @course.try(:channels).try(:board).try(:last).try(:live_status).to_i
      camera = time_diff.to_i > 15 ? 0 : @course.try(:channels).try(:camera).try(:last).try(:live_status).to_i
      {board: board, camera: camera}
    end

    # 根据参数查询当月课程安排
    def self.courses_by_month(user, month=nil, state=nil)
      month = month.blank? ? Time.now : month.to_time
      hash = {}
      lessons = user.live_studio_lessons.month(month)
      lessons = case state
                  when 'unclosed'
                    lessons.unclosed
                  when 'closed'
                    lessons.already_closed
                  else
                    lessons
                end
      lessons.map do |lesson|
        date = lesson.class_date.to_s
        hash[date] ||= []
        hash[date] << lesson
      end
      hash.map{|date,lessons| {date: date, lessons: lessons}}
    end

    # 过滤辅导班
    # 检索条件: subject grade status
    # 排序条件: class_date
    def self.courses_search(search_params)
      chain = LiveStudio::Course.for_sell.includes(:teacher, :lessons)
      chain = courses_filter_by_range(chain, *range_to_time(search_params[:range])) if search_params[:range]
      chain = chain.tagged_with(search_params[:tag]) if search_params[:tag]
      chain.ransack(search_params[:q])
    end

    def self.courses_for_teacher_index(user, params)
      @courses = user.live_studio_courses
      if params[:status] == 'today'
        # 根据分类过滤辅导班
        # status: today今日上课辅导班
        @courses = @courses.includes(:lessons).where(live_studio_lessons: { class_date: Date.today })
      elsif params[:status].present?
        # 根据状态过滤辅导班
        statuses = params[:status].split(',')
        @courses = @courses.where(status: LiveStudio::Course.statuses.slice(*statuses).values)
      end
      @courses.order("id desc")
    end

    def self.courses_for_student_index(user,params)
      @tickets = user.live_studio_tickets.visiable.includes(course: :teacher)
      status = params[:status]
      cate = params[:cate]
      if LiveStudio::Course.statuses.include?(status)
        # 根据状态过滤辅导班
        status = LiveStudio::Course.statuses[status]
        @tickets = @tickets.joins(:course).where(live_studio_courses: { status: status })
      elsif %w(today taste).include?(cate)
        # 根据分类过滤辅导班
        # status: today今日上课辅导班, taste: 试听辅导班
        @tickets = courses_for_filter(user, cate)
      end
      @tickets
    end

    def self.taste_course_ticket(user, course)
      raise APIErrors::CourseTasteLimit unless course.taste_count.to_i > 0
      LiveService::ChatAccountFromUser.new(user).instance_account
      course.taste_tickets.find_or_create_by(student: user)
    end

    # 创建订单
    # 添加 chat account
    # 返回 order
    def self.create_order(user, course, params)
      order = Payment::Order.new(params.merge(course.order_params))
      order.errors.add(:payment_password, :invalid) if order.account? && user.cash_account!.password_digest.present? && !user.cash_account!.authenticate(params[:payment_password])
      order.user = user
      order
    end

    # 清理全部完成的辅导班
    def self.clean_courses
      LiveStudio::Course.teaching.where("completed_lessons_count >= lessons_count").find_each(batch_size: 200).map(&:complete!)
    end

    private

    def instance_studio
    end

    # 初始化聊天群组，并且初始化群员
    def instance_team_and_members(teacher_account, members)
      team_manager = LiveService::ChatTeamManager.new(nil)
      team_manager.instance_team(@course, teacher_account)
      team_manager.add_to_team([teacher_account], 'owner', false) # 教师最为owner加入群组
      team_manager.add_to_team(members, 'normal') # 加入现有学生进入群组
    end

    def instance_account(user)
      LiveService::ChatAccountFromUser.new(user).instance_account
    end

    class << self
      private

      # 分类查询辅导班
      # taste 试听辅导班
      # today 今日辅导班
      # 只提供查询链，请自行分页
      def courses_for_filter(user, cate)
        # 试听辅导班
        return user.live_studio_taste_tickets.includes(course: :teacher) if 'taste' == cate
        # 今日辅导班
        # TODO 查询逻辑有点复杂，可以考虑通过增加冗余字段来简化查询
        course_ids = user.live_studio_tickets.visiable.map(&:course_id)
        today_course_ids = LiveStudio::Lesson.where(course_id: course_ids, class_date: Date.today).map(&:course_id).uniq
        user.live_studio_tickets.visiable.includes(course: [:teacher, :lessons]).where(course_id: today_course_ids)
      end

      # 上课区间过滤
      def courses_filter_by_range(chain, start_time, end_time)
        chain.where('(start_at BETWEEN :start AND :end OR end_at BETWEEN :start AND :end OR (start_at < :start AND end_at > :end))', start: start_time, end: end_time)
      end

      # 时间区间转换为时间点
      def range_to_time(range_name)
        return [Time.now, Time.now] unless range_name =~ /\A\d+\_(month)|(year)|(day)|(week)s?\z/
        num, unit = range_name.split('_')
        [Time.now.beginning_of_day, num.to_i.send(unit).since.beginning_of_day]
      end

      def query_by_params(courses, params)
        %w(subject grade status).each do |i|
          if params[i].present? && params[i] != 'all'
            courses = courses.where(i => i == 'status' ? LiveStudio::Course.statuses[params[i]] : params[i])
          end
        end
        [["price_floor","price_ceil"], ["class_date_floor","class_date_ceil"], ["lessons_count_floor", "lessons_count_ceil"], ["preset_lesson_count_floor", "preset_lesson_count_ceil"]].each do |i|
          column = i.first.gsub('_floor', '')
          column = 'lessons_count' if column == 'preset_lesson_count'
          courses = courses.where("#{column} >= ?",params[i.first]) if params[i.first].present?
          courses = courses.where("#{column} <= ?",params[i.last]) if params[i.last].present?
        end
        if params[:city_name].present?
          city =  City.find_by(name: params[:city_name])
          courses = courses.where(city_id: city.id) if city.present?
        end

        if params[:sort_by].present?
          # 排序方式,多个排序字段用-隔开,默认倒序,需要正序加上.asc后缀 例如: created_at-price.asc-buy_tickets_count.asc
          order_str =
            params[:sort_by].split('-').map{ |i|
              column = i.split('.')[0]
              order_sort = i.split('.')[1].downcase == 'desc' ? 'DESC NULLS LAST' : 'ASC'
              "#{column} #{order_sort}" if LiveStudio::Course.column_names.include?(column)
            }.join(',')
          courses = courses.order(order_str)
        else
          # 初始搜索,没有参数, 默认审核通过时间降序显示 null值排在后面
          courses = courses.order("published_at desc NULLS LAST")
        end

        courses.order(id: :desc)
      end
    end
  end
end
