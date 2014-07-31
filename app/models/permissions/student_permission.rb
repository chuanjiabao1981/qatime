module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
      allow :home,[:index]
      allow :groups,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow :topics,[:new,:create,:show]
      allow :replies,[:create]
      allow :pictures,[:new,:create]
      allow "students/faqs", [:index, :show]
      allow "students/faq_topics", [:show]

      allow :faqs, [:show]
      allow :faq_topics, [:show]
      allow 'students/home',[:main]
      allow 'students/registrations',[:edit,:update,:show]
      allow 'students/recharge_records',[:index,:new,:create]
      allow 'students/courses',[:purchase]
    end
  end
end