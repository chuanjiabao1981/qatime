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



    # 过滤辅导班
    # 检索条件: subject grade status
    # 排序条件: class_date
    def self.courses_search(search_params)
      @courses = LiveStudio::Course.for_sell.includes(:teacher)
      query_by_params(@courses, search_params)
    end

    def self.courses_for_teacher_index(user,params)
      @courses = user.live_studio_courses
      if LiveStudio::Course.statuses.include?(params[:status])
        # 根据状态过滤辅导班
        status = LiveStudio::Course.statuses[params[:status]]
        @courses = @courses.where(status: status)
      elsif params[:status] == 'today'
        # 根据分类过滤辅导班
        # status: today今日上课辅导班
        @courses = @courses.includes(:lessons).where(live_studio_lessons: { class_date: Date.today })
      end
      @courses
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
      LiveService::ChatAccountFromUser.new(user).instance_account
      course.taste_tickets.find_or_create_by(student: user)
    end

    # 创建订单
    # 添加 chat account
    # 返回 order
    def self.create_order(user, course, params)
      order = Payment::Order.new(params.merge(course.order_params))
      order.user = user
      order.save && LiveService::ChatAccountFromUser.new(order.user).instance_account
      order
    end

    private

    # 分类查询辅导班
    # taste 试听辅导班
    # today 今日辅导班
    # 只提供查询链，请自行分页
    def self.courses_for_filter(user, cate)
      # 试听辅导班
      return user.live_studio_taste_tickets.includes(course: :teacher) if 'taste' == cate
      # 今日辅导班
      # TODO 查询逻辑有点复杂，可以考虑通过增加冗余字段来简化查询
      user.live_studio_tickets.visiable.includes(course: [:teacher, :lessons]).where(live_studio_lessons: { class_date: Date.today })
    end

    def self.query_by_params(courses, params)
      %w(subject grade status).each do |i|
        if params[i].present? && params[i] != 'all'
          courses = courses.where(i => i == 'status' ? LiveStudio::Course.statuses[params[i]] : params[i])
        end
      end
      if params[:sort_by].present?
        # 排序方式,多个排序字段用-隔开,默认倒序,需要正序加上.asc后缀 例如: created_at-price.asc-buy_tickets_count.asc
        order_str =
          params[:sort_by].split('-').map{ |i|
            column = i.split('.')[0]
            "#{column} #{i.split('.')[1] || 'desc'}" if LiveStudio::Course.column_names.include?(column)
          }.join(',')
        courses.order(order_str)
      end
      courses
    end

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
  end
end
