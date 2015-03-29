module Permissions
  class ManagerPermission < BasePermission
    def initialize(user)
      allow "managers/register_codes",[:index,:create,:new]
      allow "managers/lessons",[:state,:update]

      allow "managers/home",[:main]

      allow :students,[:index,:search]
      allow :home,[:index]
      allow :schools,[:index,:new,:create,:show,:edit,:update]
      allow :teachers,[:index,:new,:create,:show,:edit,:update]
      allow :curriculums,[:index,:show]
      allow :learning_plans,[:new,:teachers,:create,:index]
      allow :courses,[:show]

      allow :sessions,[:destroy]

    end
  end
end