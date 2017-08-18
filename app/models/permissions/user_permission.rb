module Permissions
  class UserPermission < BasePermission
    def initialize(user)
      allow :qa_faqs,[:index, :show, :static_page, :agreements, :agreement, :teacher_usages, :teacher_usage, :student_usages, :student_usage]
      allow :qa_faqs,[:show] do |faq|
        faq && faq.common?
      end
      allow :teachers, [:profile]

      allow :customized_course_message_boards,[:show] do |customized_course_message_board|
        customized_course_message_board and
            customized_course_message_board.customized_course.all_participants.include?(user.id)
      end
      allow :customized_course_messages,[:new,:create] do |customized_course_message_board|
        customized_course_message_board and customized_course_message_board.all_participants.include?(user.id)
      end
      allow :customized_course_messages,[:edit,:update] do |customized_course_message|
        customized_course_message and customized_course_message.author.id == user.id
      end
      allow :customized_course_messages,[:show] do |customized_course_message|
        customized_course_message and
            customized_course_message.customized_course_message_board.all_participants.include?(user.id)
      end

      allow :customized_course_message_replies,[:create] do |customized_course_message|
        customized_course_message and
            customized_course_message.customized_course_message_board.all_participants.include?(user.id)
      end

      allow :customized_course_message_replies,[:show] do |customized_course_message_reply|
        customized_course_message_reply and
            customized_course_message_reply.customized_course_message.customized_course_message_board.all_participants.include?(user.id)
      end
      allow :customized_course_message_replies,[:edit,:update] do |customized_course_message_reply|
        customized_course_message_reply and
            customized_course_message_reply.author.id == user.id
      end

      allow :notifications,[:show] do |notification|
        notification and notification.receiver_id == user.id
      end

      allow 'live_studio/courses', [:index, :taste, :play, :show, :refresh_current_lesson,:schedule_sources, :live_status, :live_info]
      allow 'live_studio/interactive_courses', [:index, :show, :play, :live_info]
      allow 'live_studio/video_courses', [:index, :show, :taste, :deliver]

      allow 'qawechat/users', [:remove_wechat]
      allow :home,[:index,:new_index,:switch_city, :search, :search_teachers, :search_courses, :teachers, :replays, :replay]
      allow 'chat/teams', [:finish, :members, :member_visit]
      allow 'ajax/captchas', [:create, :verify]
      allow 'ajax/data', [:option_cities, :option_schools]
      allow 'welcome', [:download]

      allow 'passwords', [:new, :create, :edit, :update, :new_payment_password, :update_payment_password]

      ## begin api permission
      # 辅导班接口
      api_allow :GET, "/api/v1/live_studio/courses"
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+"
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+/realtime"
      api_allow :GET, "/api/v1/live_studio/interactive_courses/[\\w-]+/realtime"
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+/play_info"
      api_allow :GET, "/api/v1/live_studio/courses/[\\w-]+/live_status"

      # 安全设置
      api_allow :PUT, "/api/v1/users/[\\w-]+/email" do |resource|
        resource.id == user.id
      end
      api_allow :PUT, "/api/v1/users/[\\w-]+/login_mobile" do |resource|
        resource.id == user.id
      end
      api_allow :PUT, "/api/v1/users/[\\w-]+/password" do |resource|
        resource.id == user.id
      end
      api_allow :post, "/api/v1/users/[\\w-]+/wechat" do |resource|
        resource.id == user.id
      end
      api_allow :delete, "/api/v1/users/[\\w-]+/wechat" do |resource|
        resource.id == user.id
      end

      ## end api permission
    end
  end
end
