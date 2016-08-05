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

    # 分类查询辅导班
    # taste 试听辅导班
    # today 今日辅导班
    # 只提供查询链，请自行分页
    def self.courses_for_filter(user, cate)
      # 试听辅导班
      return user.live_studio_taste_tickets.includes(course: :teacher) if 'taste' == cate
      # 今日辅导班
      # TODO查询逻辑有点复杂，可以考虑通过增加冗余字段来简化查询
      user.live_studio_tickets.visiable.includes(course: [:teacher, :lessons]).where(live_studio_lessons: { class_date: Date.today })
    end

    # 过滤辅导班
    # 检索条件: subject grade status
    # 排序条件: class_date
    def self.courses_search(search_params)
      LiveStudio::Course.for_sell.by_subject(search_params[:subject]).by_status(search_params[:status]).
        by_grade(search_params[:grade]).class_date_sort(search_params[:class_date_sort]).includes(:teacher)
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
  end
end
