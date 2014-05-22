module Permissions
  class StudentPermission < BasePermission
    def initialize(user)
      allow :home,[:index]
      allow :groups,[:index,:show]
      allow :courses,[:show]
      allow :sessions,[:destroy]
      allow :topics,[:new,:create,:show]
      allow :pictures,[:new,:create]
      allow 'students/home',[:main]
      allow 'students/registrations',[:edit,:update,:show]
      allow 'students/recharge_records',[:index,:new,:create]
    end
  end
end