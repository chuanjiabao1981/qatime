module Permissions
  class GuestPermission < BasePermission
    def initialize
      allow :home,[:index]
      allow :sessions,[:new,:create]
      allow :students,[:new,:create]
      allow :teachers,[:new,:create]
      allow :teaching_videos,[:show]
      allow :qa_faqs,[:index]
      allow :qa_faqs,[:show] do |faq|
        not faq.teacher?
      end
    end
  end
end