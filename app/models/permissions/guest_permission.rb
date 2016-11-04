module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :home,[:index,:new_index]
      allow :sessions,[:new,:create]
      allow :students,[:new,:create]
      allow :teachers,[:new,:create,:profile]
      allow :teaching_videos,[:show]
      allow :qa_faqs,[:index,:courses,:show]
      allow :qa_faqs,[:show] do |faq|
        faq && !faq.teacher?
      end

      # wechat payment callback url
      allow 'payment/orders', [:notify]
      allow 'payment/transactions', [:notify]
      allow 'ajax/captchas', [:create, :verify]
      allow 'passwords', [:edit, :update]

      allow 'welcome', [:download, :courses]
      allow 'passwords', [:new, :create]
      allow 'live_studio/courses', [:index, :show]

      ## begin api permission
      # system
      api_allow :GET, "/api/v1/system/health"
      api_allow :POST, "/api/v1/system/test"
      api_allow :GET, "/api/v1/system/ping"
      api_allow :GET, "/api/v1/system/check_update"

      #app_constant
      api_allow :GET, "/api/v1/app_constant"
      api_allow :GET, "/api/v1/app_constant/grades"
      api_allow :GET, "/api/v1/app_constant/provinces"
      api_allow :GET, "/api/v1/app_constant/cities"
      api_allow :GET, "/api/v1/app_constant/schools"
      api_allow :GET, "/api/v1/app_constant/im_app_key"

      # sessions
      api_allow :POST, "/api/v1/sessions"

      api_allow :PUT, "/api/v1/password"

      api_allow :GET, "/api/v1/user/register_code_valid"
      api_allow :POST, "/api/v1/user/register"

      # captcha
      api_allow :POST, "/api/v1/captcha"
      api_allow :POST, "/api/v1/captcha/verify"

      ## end api permission
    end
  end
end
