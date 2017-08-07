module Permissions
  class StudentPermission < UserPermission
    def initialize(user)
      super(user)
      allow :home,[:index,:new_index,:switch_city]
      allow :curriculums,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow :qa_faqs,[:show] do |faq|
        faq && !faq.teacher?
      end

      allow :topics,[:new,:create] do |topicable|
        topicable_permission(topicable,user)
      end
      allow :topics,[:show]
      allow :topics,[:edit,:update,:destroy] do |topic|
        topic and topic.author_id == user.id
      end
      allow :messages, [:index, :show]
      allow :replies,[:create] do |topic|
        topic and topic.topicable and topicable_permission(topic.topicable,user)
      end
      allow :replies,[:edit,:update] do |reply|
        reply and reply.author_id == user.id
      end
      allow :pictures,[:new,:create]
      allow :pictures,[:destroy] do |picture|
        picture and picture.author and picture.author_id == user.id
      end
      allow :videos,[:create]
      allow "students/faqs", [:index, :show]
      allow "students/faq_topics", [:show]
      allow :teaching_videos,[:show]

      allow :vip_classes, [:show] do |vip_class|
        vip_class
      end
      allow :questions,[:index,:student,:teachers,:new]
      allow :questions,[:create] do |learning_plan|
       learning_plan and learning_plan.student_id  == user.id
      end
      allow :questions,[:edit,:update] do |question|
        question and question.student_id == user.id
      end

      allow :questions,[:show] do |question|
        #暂时给所有的学生都开放
        question
        #只给问题的owner或者有valid的learning_plan
        #question and (question.student_id == user.id or  user.select_first_valid_learning_plan(question.vip_class))
      end


      allow :students,[:show,:edit,:update,:info,:teachers,
                       :questions,:topics,:customized_courses,
                       :customized_tutorial_topics,:homeworks,:solutions,
                       :notifications] do |student|
        student and student.id == user.id
      end

      allow :notifications, [:index] do |resource_user|
        resource_user && user.id == resource_user.id
      end

      allow :notifications, [:show] do |notification|
        notification && notification.receiver_id == user.id
      end

      allow :customized_courses,[:show,:topics,:homeworks,:solutions,:action_records] do |customized_course|
        customized_course and customized_course.student_id == user.id
      end
      allow :customized_tutorials,[:show] do |customized_tutorial|
        customized_tutorial and customized_tutorial.customized_course.student_id == user.id
      end

      allow :homeworks ,[:show] do |homework|
        homework and homework.customized_course.student_id == user.id
      end

      allow :solutions,[:new,:create] do |examination|
        examination and examination.student_id == user.id
      end

      allow :solutions,[:show,:edit,:update] do |solution|
        solution and solution.student_id == user.id
      end


      allow :exercises,[:show] do |exercise|
        exercise and exercise.customized_tutorial.customized_course.student.id == user.id
      end




      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow 'students/home',[:main]
      allow 'students/recharge_records',[:index,:new,:create]
      allow 'students/courses',[:purchase]
      allow :lessons,[:show]
      allow :comments,[:create,:show]
      allow :comments,[:edit,:update,:destroy] do |comment|
        comment and comment.author_id  == user.id
      end


      allow :tutorial_issue_replies,[:show] do |tutorial_issue|
        tutorial_issue and tutorial_issue.customized_course.student_id == user.id
      end

      allow :tutorial_issues, [:new,:create] do |customized_tutorial|
        customized_tutorial and customized_tutorial.customized_course.student_id == user.id
      end
      allow :tutorial_issues, [:show,:edit,:update] do |tutorial_issue|
        tutorial_issue and tutorial_issue.author_id == user.id
      end


      allow :course_issues,[:new,:create] do |customized_course|
        customized_course and customized_course.student_id == user.id
      end

      allow :course_issues,[:show,:edit,:update] do |course_issue|
        course_issue and course_issue.author_id == user.id
      end


      ### start students namespace
      allow 'students/orders', [:index]
      allow 'students/orders', [:pay]

      ### end students namespace

      # allow :course_issue_replies,[:create] do |course_issue|
      #   course_issue and course_issue.customized_course.student_id == user.id
      # end
      #
      # allow :course_issue_replies,[:edit,:update] do |course_issue_reply|
      #   course_issue_reply and course_issue_reply.author_id == user.id
      # end


      allow :course_issue_replies,[:show] do |course_issue_reply|
        course_issue_reply and course_issue_reply.customized_course.student_id == user.id
      end

      allow :corrections,[:show] do |solution|
        solution and solution.examination and solution.examination.student_id == user.id
      end
      allow 'live_studio/orders', [:new, :create, :pay, :show]

      ## begin live studio permission
      allow 'live_studio/student/students', [:schedules, :schedule_data, :settings, :tastes, :taste_records]
      allow 'settings', [:create, :update]
      allow 'live_studio/student/courses', [:index, :show]
      allow 'live_studio/student/interactive_courses', [:index, :show]
      allow 'live_studio/student/video_courses', [:index]
      allow 'live_studio/student/customized_groups', [:index]
      allow 'live_studio/customized_groups', [:index, :show, :for_free]
      allow 'live_studio/courses', [:index, :show, :for_free]
      allow 'live_studio/lessons', [:show, :play, :videos]

      allow 'live_studio/lessons', [:replay] do |lesson|
        lesson.replayable && lesson.replayable_for?(user)
      end

      allow 'live_studio/interactive_lessons', [:replay] do |lesson|
        lesson.replayable && lesson.replayable_for?(user)
      end

      allow 'live_studio/video_lessons', [:play] do |lesson|
        lesson.tastable || lesson.play_for?(user)
      end
      ## end live studio permission

      # payment permission
      allow 'payment/orders', [:index, :show, :destroy, :result, :pay, :cancel_order, :refund, :refund_create, :cancel_refund] do |resource|
        resource.id == user.id
      end
      allow 'payment/change_records', [:index] do |resource|
        resource.id == user.id
      end
      allow 'payment/recharges', [:new, :create] do |resource|
        resource.id == user.id
      end
      allow 'payment/transactions', [:show, :result] do |resource|
        resource.id == user.id
      end
      allow 'payment/transactions', [:pay]
      allow 'payment/withdraws', [:new, :create, :complete, :cancel]

      allow 'payment/users', [:cash, :recharges, :withdraws, :consumption_records, :refunds] do |resource|
        resource.id == user.id
      end

      allow 'wap/live_studio/orders', [:new, :create]
      allow 'wap/live_studio/courses', [:show, :download]
      allow 'wap/live_studio/video_courses', [:show]
      allow 'wap/live_studio/customized_groups', [:show]
      allow 'wap/softwares', [:index]
      allow 'wap/payment/orders', [:show, :pay]

      # payment permission

      ## begin api permission
      api_allow :DELETE, "/api/v1/sessions"

      # 学生辅导班列表
      api_allow :GET, "/api/v1/live_studio/students/[\\w-]+/courses/full" do |student|
        student && student.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/students/[\\w-]+/courses/[\\w-]+" do |student|
        student && student.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/students/[\\w-]+/courses" do |student|
        student && student.id == user.id
      end
      api_allow :POST, "/api/v1/live_studio/courses/[\\w-]+/orders"
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+/replays"
      api_allow :GET, "/api/v1/live_studio/lessons/[\\w-]+/replay"

      # 游客绑定账号
      api_allow :POST, "/api/v1/user/guests/[\\w-]+/bind"

      # 学生个人信息接口
      api_allow :GET, "/api/v1/students/[\\w-]+/info" do |student|
        student && student.id == user.id
      end
      api_allow :PUT, "/api/v1/students/[\\w-]+" do |student|
        student && student.id == user.id
      end
      api_allow :PUT, "/api/v1/students/[\\w-]+/profile" do |student|
        student && student.id == user.id
      end
      api_allow :GET, "/api/v1/students/[\\w-]+/schedule" do |student|
        student && student.id == user.id
      end
      api_allow :PUT, "/api/v1/students/[\\w-]+/parent_phone" do |student|
        student && student.id == user.id
      end
      api_allow :GET, "/api/v1/live_studio/students/[\\w-]+/schedule" do |student|
        student && student.id == user.id
      end

      ## 一对一权限
      api_allow :GET, 'live_studio/students/\d+/interactive_courses' do |student|
        student == user
      end
      api_allow :POST, "/api/v1/live_studio/interactive_courses/[\\w-]+/orders"
      ##

      ## 视频课
      api_allow :GET, '/api/v1/live_studio/students/\d+/video_courses'
      api_allow :GET, '/api/v1/live_studio/students/\d+/video_courses/list'
      api_allow :GET, '/api/v1/live_studio/students/\d+/video_courses/tasting'
      api_allow :GET, '/api/v1/live_studio/students/\d+/video_courses/tasting_list'
      api_allow :GET, '/api/v1/live_studio/video_lessons/\d+/play'
      api_allow :POST, "/api/v1/live_studio/video_courses/[\\w-]+/orders"
      api_allow :POST, "/api/v1/live_studio/video_courses/[\\w-]+/deliver_free"
      api_allow :POST, "/api/v1/live_studio/video_courses/[\\w-]+/taste"
      ## 视频课


      ## 专属课 start
      api_allow :GET, '/api/v1/live_studio/students/\d+/customized_groups' # 我的专属课列表
      api_allow :GET, '/api/v1/live_studio/students/\d+/customized_groups/tasting' # 我的专属课试听列表
      ## 专属课 end

      # 消息通知
      api_allow :GET, "/api/v1/users/[\\w-]+/notifications"
      api_allow :PUT, "/api/v1/notifications/[\\w-]+/read"
      # 消息通知结束

      ## 通知设置
      api_allow :GET, "/api/v1/users/[\\w-]+/notifications/settings" # 查询通知设置
      api_allow :PUT, "/api/v1/users/[\\w-]+/notifications/settings" # 修改通知设置
      ## end 通知设置

      # payment
      api_allow :GET, "/api/v1/payment/orders/[\\w-]+/result"
      api_allow :GET, "/api/v1/payment/orders"
      api_allow :PUT, "/api/v1/payment/orders/[\\w-]+/cancel"
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/recharges"
      api_allow :POST, "/api/v1/payment/users/[\\w-]+/recharges"
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/cash"
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/consumption_records"
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/withdraws"
      api_allow :POST, "/api/v1/payment/users/[\\w-]+/withdraws"
      api_allow :PUT, "/api/v1/payment/users/[\\w-]+/withdraws/:id/cancel"
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/refunds/info"
      api_allow :POST, "/api/v1/payment/users/[\\w-]+/refunds"
      api_allow :GET, "/api/v1/payment/users/[\\w-]+/refunds"
      api_allow :PUT, "/api/v1/payment/users/[\\w-]+/refunds/:id/cancel"
      api_allow :POST, "/api/v1/payment/users/[\\w-]+/withdraws/ticket_token" # 提现token
      ## end api permission

      ## 获取授权token
      api_allow :POST, "/api/v1/ticket_tokens/cash_accounts/update_password"
      ## end 获取授权token

      ### 修改支付密码
      api_allow :POST, "/api/v1/payment/cash_accounts/[\\w-]+/password" # 设置支付密码
      api_allow :POST, "/api/v1/payment/cash_accounts/[\\w-]+/password/ticket_token" # 修改支付密码
      ## end 修改支付密码

      ## 苹果内购
      api_allow :POST, "/api/v1/payment/itunes_products" # 商品列表
      api_allow :POST, "/api/v1/payment/itunes_products/[\\w-]+/recharges" # 充值下单
      api_allow :POST, "/api/v1/payment/recharges/[\\w-]+/verify_receipt" # 苹果内购充值校验
      ## end 苹果内购
    end
private

    def topicable_permission(topicable,user)
      return false if topicable.nil?
      if topicable.instance_of? Lesson
        ##TODO:: 这里应该是购买的学生才能看
        true
      end
    end
  end
end
