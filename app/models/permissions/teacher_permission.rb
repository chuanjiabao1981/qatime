module Permissions
  class TeacherPermission < UserPermission
    STATE_EVENTS = Examination.state_machines[:state].events.map(&:name) - [:handle]

    def initialize(user)
      super(user)

      allow :curriculums,[:index,:show]
      allow :home,[:index,:new_index,:switch_city]
      allow :pictures,[:new,:create]
      allow :pictures,[:destroy] do |picture|
        picture and picture.author and picture.author_id == user.id
      end
      allow :messages, [:index, :show]
      allow :qa_faqs,[:show] do |faq|
        faq && !faq.student?
      end

      allow :questions,[:index,:show,:teacher]
      allow :questions,[:show]
      allow :answers,[:create] do |question|
        question != nil and question.teachers and question.teacher_ids.include?(user.id)

      end
      allow :answers,[:edit,:update] do |answer|
        answer and answer.teacher_id == user.id
      end
      allow :vip_classes,[:show]

      allow "teachers/curriculums",[:edit_courses_position,:update] do |curriculum|
        curriculum and curriculum.teacher_id == user.id
      end
      allow "teachers/courses",[:new,:create] do |curriculum|
        curriculum and curriculum.teacher_id == user.id
      end

      allow "teachers/courses",[:edit,:update] do |course|
        course and course.teacher_id == user.id
      end

      allow "teachers/lessons",[:new,:create] do |course|
        course and course.teacher_id == user.id
      end

      allow "teachers/lessons",[:edit,:update,:destroy] do |lesson|
        lesson and lesson.teacher_id == user.id
      end

      allow "videos",[:create,:show]
      allow "videos",[:update] do |video|
        video and video.author_id == user.id
      end

      allow "teaching_videos", [:create, :show]
      allow :topics,[:new,:create] do |topicable|
        topicable_permission(topicable,user)
      end
      allow :topics,[:show]
      allow :topics,[:edit,:update,:destroy] do |topic|
        topic and topic.author_id == user.id
      end

      allow "teachers/home",[:main]
      allow :teachers, [:profile]

      allow :teachers,[:edit,:update,:show,:lessons_state,:students,:curriculums,
                       :info,:questions,:topics,:customized_courses,
                       :customized_tutorial_topics,:homeworks,:solutions,:notifications] do |teacher|
        teacher and teacher.id == user.id
      end

      allow :notifications, [:index] do |resource_user|
        resource_user && user.id == resource_user.id
      end

      allow :notifications, [:show] do |notification|
        notification && notification.receiver_id == user.id
      end

      allow :replies,[:create] do |topic|
        topic and topic.topicable and topicable_permission(topic.topicable,user)
      end
      allow :replies,[:edit,:update] do |reply|
        reply and reply.status == "open" and reply.author_id == user.id
      end

      allow :lessons,[:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow "teachers/faqs", [:index, :show]
      allow "teachers/faq_topics", [:show]
      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow :comments,[:create,:show]
      allow :comments,[:edit,:update,:destroy] do |comment|
        comment and comment.author_id  == user.id
      end
      allow :customized_courses,[:show,:topics,:homeworks,:solutions,:action_records,:update, :update_desc] do |customized_course|
        user and customized_course.teacher_ids.include?(user.id)
      end
      allow :customized_tutorials,[:new,:create] do |customized_course|
        user and customized_course.teacher_ids.include?(user.id)
      end
      allow :customized_tutorials,[:edit,:update] do |customized_tutorial|
        user and (customized_tutorial.teacher_id == user.id or
            customized_tutorial.customized_course.teacher_ids.include?(user.id)) and customized_tutorial.template.nil?
      end

      allow :customized_tutorials,[:show] do |customized_tutorial|
        user and (customized_tutorial.teacher_id == user.id or
            customized_tutorial.customized_course.teacher_ids.include?(user.id))
      end

      allow :homeworks,[:new,:create] do |customized_course|
        customized_course and customized_course.teacher_ids.include?(user.id)
      end

      allow :homeworks,[:show,:edit,:update]+STATE_EVENTS do |homework|
        homework and homework.teacher_id == user.id or homework.customized_course.teacher_ids.include?(user.id)
      end

      allow :solutions,[:show]+STATE_EVENTS do |solution|
        solution and solution.examination.response_teachers.include?(user)
      end


      allow :corrections,[:create,:show] do |solution|
        solution and solution.examination and solution.examination.response_teachers.include?(user)
      end

      allow :corrections,[:edit,:update] do |correction|
        correction and correction.status == "open" and correction.teacher_id == user.id and correction.template_id.nil?
      end

      allow :exercises,[:new,:create] do |customized_tutorial|
        customized_tutorial  and customized_tutorial.teacher_id == user.id
      end

      allow :exercises,[:show]+STATE_EVENTS do |exercise|
        exercise and
            (exercise.teacher_id == user.id or
                exercise.customized_tutorial.customized_course.teacher_ids.include?(user.id))
      end

      allow :exercises, [:edit,:update] do |exercise|
        exercise and
            (exercise.teacher_id == user.id or
                exercise.customized_tutorial.customized_course.teacher_ids.include?(user.id)) and
            exercise.template.nil?
      end

      allow :tutorial_issues,[:show]+STATE_EVENTS do |tutorial_issue|
        tutorial_issue and tutorial_issue.customized_course.teacher_ids.include?(user.id)
      end

      allow :tutorial_issue_replies,[:show,:create] do |tutorial_issue|
        tutorial_issue and tutorial_issue.customized_course.teacher_ids.include?(user.id)
      end
      allow :tutorial_issue_replies,[:edit,:update] do |tutorial_issue_reply|
        tutorial_issue_reply and tutorial_issue_reply.author_id == user.id
      end

      allow :course_issues,[:show]+STATE_EVENTS do |course_issue|
        course_issue and course_issue.customized_course.teacher_ids.include?(user.id)
      end

      allow :course_issue_replies,[:create] do |course_issue|
        course_issue and course_issue.customized_course.teacher_ids.include?(user.id)
      end
      allow :course_issue_replies,[:edit,:update] do |course_issue_reply|
        course_issue_reply and course_issue_reply.author_id == user.id and course_issue_reply.status == "open"
      end
      allow :course_issue_replies,[:show] do |course_issue_reply|
        course_issue_reply and course_issue_reply.customized_course.teacher_ids.include?(user.id)
      end

      #######begine course library permission###############
      allow "course_library/solutions",[:edit, :update, :show, :destroy, :mark_delete, :video] do |solution|
        solution and solution.homework.course.directory.syllabus.author_id == user.id
      end
      allow "course_library/solutions",[:index, :new, :create] do |homework|
        homework and homework.course.directory.syllabus.author_id == user.id
      end
      allow "course_library/homeworks",[:edit, :update, :show, :destroy, :mark_delete] do |homework|
        homework and homework.course.directory.syllabus.author_id == user.id
      end
      allow "course_library/homeworks",[:index, :new, :create] do |course|
        course and course.directory.syllabus.author_id == user.id
      end
      allow "course_library/courses",[:available_customized_courses_for_publish,
                                      :publish,:customized_tutorials,:un_publish,:sync,
                                      :index, :new, :edit, :update, :create, :show, :destroy,
                                      :mark_delete, :move_higher, :move_lower, :move_dir] do |course|
        course and course.directory.syllabus.author_id == user.id
      end
      allow "course_library/courses",[:index, :new, :create] do |directory|
        directory and directory.syllabus.author_id == user.id
      end
      allow "course_library/directories",[:edit, :update, :show, :move_higher, :move_lower] do |directory|
        directory and directory.syllabus.author_id == user.id
      end
      allow "course_library/directories",[:new, :create] do |syllabus|
        syllabus and syllabus.author_id == user.id
      end
      allow "course_library/syllabuses",[:edit, :update, :show] do |syllabus|
        syllabus and syllabus.author_id == user.id
      end
      allow "course_library/syllabuses",[:index, :new, :create] do |teacher|
        teacher and teacher.id == user.id
      end

      allow "course_library/course_publications",[:index,:new,:create] do |course|
        user and user.id == course.author_id
      end
      allow "course_library/course_publications",[:edit,:update,:destroy,:sync] do |course_publication|
        course_publication and user.id == course_publication.course.author_id
      end
      #######end course library permission##################
      allow :qa_file_quoters,[:index, :new, :edit, :update, :create, :show, :destroy]

      ## begin live studio permission
      allow 'live_studio/teacher/courses', [:index, :show, :edit, :update, :sync_channel_streams, :channel, :close, :update_class_date, :update_lessons, :destroy] do |teacher, course, action|
        # 只有初始化的辅导班可以编辑
        permission = %w(edit update).include?(action) ? course.init? : true
        teacher && teacher == user && permission
      end

      allow 'live_studio/teacher/homeworks', [:index] do |teacher|
        teacher && teacher == user
      end

      allow 'live_studio/teacher/student_homeworks', [:index] do |teacher|
        teacher && teacher == user
      end

      allow 'live_studio/teacher/questions', [:index] do |teacher|
        teacher && teacher == user
      end

      allow 'live_studio/teacher/teachers', [:schedules, :schedule_data, :settings]
      allow 'settings', [:create, :update]

      allow 'live_studio/teacher/lessons', [
          :index, :show, :new, :create, :edit, :update, :destroy,
          :begin_live_studio, :end_live_studio, :ready, :complete
      ] do |teacher, course, action|
        # 课程的辅导班初始化状态可以变新增 编辑 删除 | 招生中状态可以编辑 | 上课中状态可以调课
        permission = (%w(new create edit update destroy).include?(action) ? course.init? : true) || (%w(edit update).include?(action) ? course.published? : true) || (%w(create update).include?(action) ? course.teaching? : true)
        teacher && teacher == user && permission
      end

      allow 'live_studio/courses', [:new, :create, :preview]
      allow 'live_studio/courses', [:update_notice, :publish, :edit, :update] do |course|
        course.teacher_id == user.id
      end
      allow 'live_studio/helps', [:course]

      allow 'live_studio/teacher/course_invitations', [:index, :destroy]

      allow 'live_studio/announcements', [:index, :create, :update] do |course|
        if course.is_a?(LiveStudio::Course) || course.is_a?(LiveStudio::CustomizedGroup)
          course && course.teacher_id == user.id
        else
          course && course.teachers.include?(user)
        end
      end

      ## 一对一 start
      allow 'live_studio/teacher/interactive_courses', [:index, :index]
      allow 'live_studio/interactive_courses', [:preview]
      ## 一对一 end

      ## 视频课 start
      allow 'live_studio/teacher/video_courses', [:index, :new, :create]
      allow 'live_studio/teacher/video_courses', [:destroy, :edit, :update] do |teacher|
        teacher && teacher == user
      end
      allow 'live_studio/video_courses', [:preview]
      ## 视频课 end

      allow 'live_studio/teacher/customized_groups', [:index]
      allow 'live_studio/customized_groups', [:preview]

      allow 'live_studio/homeworks', [:index, :new, :create] do |group|
        group && user.live_studio_customized_groups.include?(group)
      end

      # 提问
      allow 'live_studio/questions', [:index]
      allow 'live_studio/answers', [:new, :create] do |question|
        question && question.teacher_id == user.id
      end
      allow 'live_studio/answers', [:edit, :update] do |answer|
        answer && answer.user == user
      end

      # 作业批改
      allow 'live_studio/corrections', [:new, :create] do |student_homework|
        student_homework && student_homework.homework.user == user
      end
      # 重新批改
      allow 'live_studio/corrections', [:edit, :update] do |correction|
        correction && correction.user == user
      end

      # 学生提交的作业
      api_allow :GET, '/api/v1/live_studio/groups/\d+/student_homeworks' do |group|
        group && user.live_studio_customized_groups.include?(group)
      end

      # 我布置的作业
      api_allow :GET, '/api/v1/live_studio/groups/\d+/homeworks' do |group|
        group && user.live_studio_customized_groups.include?(group)
      end

      # 作业详情
      api_allow :GET, '/api/v1/live_studio/homeworks/\d+' do |homework|
        homework && homework.user == user
      end

      # 作业批改
      api_allow :POST, '/api/v1/live_studio/student_homeworks/\d+/corrections' do |student_homework|
        student_homework && student_homework.homework && student_homework.homework.user == user
      end
      # 作业重新批改
      api_allow :PATCH, '/api/v1/live_studio/corrections/\d+' do |correction|
        correction && correction.user == user
      end
      # 学生提交的作业
      api_allow :POST, '/api/v1/live_studio/teachers/\d+/student_homeworks' do |teacher|
        teacher && teacher == user
      end
      # 我布置的作业
      api_allow :POST, '/api/v1/live_studio/teachers/\d+/homeworks' do |teacher|
        teacher && teacher == user
      end

      # 上传附件
      api_allow :POST, '/api/v1/live_studio/attachments'

      # 专属课提问列表
      api_allow :GET, '/api/v1/live_studio/groups/\d+/questions' do |group|
        group && user.live_studio_customized_groups.include?(group)
      end

      # 提问详情
      api_allow :GET, '/api/v1/live_studio/questions/\d+' do |question|
        question && question.taskable && user.live_studio_customized_groups.include?(question.taskable)
      end

      # 老师回答问题
      api_allow :POST, '/api/v1/live_studio/questions/\d+/answers' do |question|
        question && question.teacher == user
      end
      # 老师修改回答
      api_allow :POST, '/api/v1/live_studio/answers/\d+' do |answer|
        answer && answer.user == user
      end
      # 老师个人中心问题列表
      api_allow :GET, '/api/v1/live_studio/teachers/\d+/questions' do |teacher|
        teacher && teacher == user
      end

      ## 专属课 start
      api_allow :GET, '/api/v1/live_studio/teachers/\d+/customized_groups' # 我的专属课列表
      api_allow :POST, '/api/v1/live_studio/events/\d+/live_start' # 开始直播上课
      api_allow :POST, '/api/v1/live_studio/events/\d+/heart_beat' # 直播心跳
      api_allow :POST, '/api/v1/live_studio/events/\d+/live_switch' # 状态切换
      api_allow :POST, '/api/v1/live_studio/events/\d+/live_end' # 直播结束

      api_allow :GET, '/api/v1/live_studio/groups/\d+/files' do |group| # 专属课文件列表
        group && user.live_studio_customized_groups.include?(group)
      end

      api_allow :POST, '/api/v1/live_studio/groups/\d+/files' do |group| # 专属课文件引用
        group && user.live_studio_customized_groups.include?(group)
      end

      # 删除课件
      api_allow :DELETE, '/api/v1/live_studio/groups/\d+/files/\d+' do |group|
        group && user.live_studio_customized_groups.include?(group)
      end
      # 课件详情
      api_allow :GET, '/api/v1/live_studio/groups/\d+/files/\d+' do |group|
        group && user.live_studio_customized_groups.include?(group)
      end

      ## 专属课 end

      ## end live studio permission

      ## begin payment permission

      allow 'payment/change_records', [:index] do |resource|
        resource.id == user.id
      end
      allow 'payment/billings', [:index]
      allow 'payment/withdraws', [:new, :create, :complete, :cancel]
      allow 'payment/transactions', [:pay]
      allow 'payment/users', [:cash, :recharges, :withdraws, :consumption_records, :earning_records, :refunds] do |resource|
        resource.id == user.id
      end
      ## end payment permission

      # 资源中心 start
      allow 'resource/files', [:create, :create_quotes, :delete_quote]
      allow 'resource/teacher/files', [:index, :new]
      allow 'resource/teacher/files', [:create, :destroy] do |teacher|
        teacher && teacher.id == user.id
      end

      allow 'live_studio/attachments', [:create]

      # 资源中心 end

      ## begin api permission
      api_allow :DELETE, "/api/v1/sessions"

      # 老师辅导班列表
      api_allow :GET, "/api/v1/live_studio/teachers/[\\w-]+/courses/full" do |teacher|
        teacher && teacher.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/teachers/[\\w-]+/courses/[\\w-]+" do |teacher|
        teacher && teacher.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/teachers/[\\w-]+/courses" do |teacher|
        teacher && teacher.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/teachers/[\\w-]+/schedule" do |teacher|
        teacher && teacher.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+/taste"
      api_allow :GET, "/api/v1/live_studio/teachers/[\\w-]+/schedules"
      api_allow :PUT, "/api/v1/live_studio/lessons/[\\w-]+/finish"
      api_allow :POST, "/api/v1/live_studio/lessons/[\\w-]+/live_start"
      api_allow :POST, "/api/v1/live_studio/lessons/[\\w-]+/live_end"
      api_allow :POST, "/api/v1/live_studio/lessons/[\\w-]+/live_info"
      api_allow :POST, "/api/v1/live_studio/lessons/[\\w-]+/heart_beat"
      api_allow :POST, "/api/v1/live_studio/lessons/[\\w-]+/live_switch"

      # 成员列表
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+/members"
      api_allow :GET, "/api/v1/live_studio/video_courses/[\\w-]+/members"
      api_allow :GET, "/api/v1/live_studio/interactive_courses/[\\w-]+/members"
      api_allow :GET, "/api/v1/live_studio/customized_groups/[\\w-]+/members"

      api_allow :POST, "/api/v1/live_studio/courses/[\\w-]+/announcements" do |teacher|
        teacher && teacher.id == user.id
      end

      ## 一对一直播
      api_allow :GET, 'live_studio/teachers/\d+/interactive_courses'
      api_allow :POST, 'live_studio/interactive_lessons/\d+/live_start' do |interactive_lesson|
        interactive_lesson && interactive_lesson.teacher_id == user.id
      end
      api_allow :POST, 'live_studio/interactive_lessons/\d+/live_switch' do |interactive_lesson|
        interactive_lesson && interactive_lesson.teacher_id == user.id
      end
      api_allow :POST, 'live_studio/interactive_lessons/\d+/live_end' do |interactive_lesson|
        interactive_lesson && interactive_lesson.teacher_id == user.id
      end
      api_allow :POST, 'live_studio/interactive_lessons/\d+/heart_beat' do |interactive_lesson|
        interactive_lesson && interactive_lesson.teacher_id == user.id
      end
      api_allow :POST, "/api/v1/live_studio/interactive_courses/[\\w-]+/announcements"
      ## 一对一直播

      ## 视频课
      api_allow :GET, 'live_studio/teachers/\d+/video_courses'

      ## 视频课

      # 老师个人信息接口
      api_allow :GET, "/api/v1/teachers/[\\w-]+/info" do |teacher|
        teacher && teacher.id == user.id
      end
      api_allow :PUT, "/api/v1/teachers/[\\w-]+" do |teacher|
        teacher && teacher.id == user.id
      end
      api_allow :PUT, "/api/v1/teachers/[\\w-]+/profile" do |teacher|
        teacher && teacher.id == user.id
      end
      ## end api permission

      api_allow :GET, "/api/v1/payment/users/[\\w-]+/cash"

      ## 获取授权token
      api_allow :GET, "/api/v1/ticket_tokens/cash_accounts/update_password"
      ## end 获取授权token

      ### 修改支付密码
      api_allow :POST, "/api/v1/payment/cash_accounts/[\\w-]+/password" # 设置支付密码
      api_allow :POST, "/api/v1/payment/cash_accounts/[\\w-]+/password/ticket_token" # 修改支付密码
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/withdraws"
      api_allow :POST, "/api/v1/payment/users/[\\w-]+/withdraws"
      api_allow :PUT, "/api/v1/payment/users/[\\w-]+/withdraws/:id/cancel"
      api_allow :POST, "/api/v1/payment/users/[\\w-]+/withdraws/ticket_token" # 提现token
      ## end 修改支付密码
      # 收益记录
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/earning_records" # 设置支付密码

      # 消息通知
      api_allow :GET, "/api/v1/users/[\\w-]+/notifications"
      api_allow :PUT, "/api/v1/notifications/[\\w-]+/read"
      # 消息通知结束

      ## 通知设置
      api_allow :GET, "/api/v1/users/[\\w-]+/notifications/settings" # 查询通知设置
      api_allow :PUT, "/api/v1/users/[\\w-]+/notifications/settings" # 修改通知设置
      ## end 通知设置

      # 资源中心 start
      api_allow :GET, "/api/v1/resource/teachers/[\\w-]+/files" do |teacher| # 我的文件
        teacher && teacher.id == user.id
      end

      api_allow :GET, "/api/v1/resource/files/[\\w-]+" do |file| # 文件详情
        file && user.files.include?(file)
      end

      api_allow :DELETE, "/api/v1/resource/files/[\\w-]+" do |file| # 文件删除
        file && user.files.include?(file)
      end

      api_allow :POST, "/api/v1/resource/files" # 文件上传
      # 资源中心 end

      # start 聊天
      api_allow :GET, '/api/v1/chat/users/\d+/teams'
      api_allow :GET, '/api/v1/chat/users/\d+/teams/\d+' do |team|
        true
      end
      # end 聊天

      api_allow :GET, '/api/v2/live_studio/teachers/\d+/schedule_data'
    end

    private

    def topicable_permission(topicable, user)
      return false if topicable.nil?
      return false unless topicable.instance_of? Lesson
      topicable.teacher_id == user.id
    end
  end
end
