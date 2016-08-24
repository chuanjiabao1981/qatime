module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :home,[:index]
      allow :sessions,[:new,:create]
      allow :students,[:new,:create]
      allow :teachers,[:new,:create]
      allow :teaching_videos,[:show]
      allow :qa_faqs,[:index,:courses,:show]
      allow :qa_faqs,[:show] do |faq|
        faq && !faq.teacher?
      end

      # wechat payment callback url
      allow 'payment/orders', [:notify]
      allow 'ajax/captchas', [:create, :verify]
      allow 'passwords', [:edit, :update]

      allow 'welcome', [:download]
      allow 'passwords', [:new, :create]
    end
  end
end
