module Permissions
  class WaiterPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions, [:destroy]
      allow :home,[:index,:new_index,:switch_city]
      allow "waiters/home", [:main]

      allow :waiters, [:customized_courses]
      allow :teachers,[:index,:show,:search,:pass,:unpass,
                       :students,:curriculums,:info,:questions,:topics,:lessons_state,:homeworks,
                       :exercises,:solutions,:customized_tutorial_topics,:notifications,
                       :customized_courses,:profile]
      allow :students,[:index,:search,:show,
                       :info,:teachers,:customized_courses,:homeworks,
                       :solutions,:account,:customized_tutorial_topics,:questions,:notifications]

      allow :customized_courses, [:show,:edit,:update,:teachers,:topics,:homeworks,:solutions, :get_sale_price] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end

      allow :customized_courses, [:new, :create, :get_sale_price, :teachers]

      ## begin live studio permission
      allow 'live_studio/waiter/courses', [:index, :show] do |resource|
        resource == user
      end
      ## end live studio permission

      allow 'payment/users', [:cash]
      allow :schools, [:index]

      ## 推荐管理
      allow 'recommend/positions', [:index, :show]
      ## 推荐管理

      # 辅导班管理
      allow 'live_studio/workstation/courses', [:index] do |owner|
        # manager可以查看自己的页面和自己工作站员工的页面
        owner && (owner == user || owner.workstation == user.workstation)
      end
      # 辅导班管理

      # 招生请求
      allow 'live_studio/workstation/course_requests', [:index] do |owner|
        owner && (owner == user || owner.workstation == user.workstation)
      end
      # 招生请求

      # 开班邀请
      allow 'live_studio/workstation/course_invitations', [:index] do |owner|
        owner && (owner == user || owner.workstation == user.workstation)
      end
      # 开班邀请
    end
  end
end
