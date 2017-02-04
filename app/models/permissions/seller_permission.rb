module Permissions
  class SellerPermission < StaffPermission
    def initialize(user)
      super(user)

      allow :sessions,[:destroy]
      allow :home,[:index,:new_index,:switch_city]
      allow "sellers/home", [:main]

      allow :sellers, [:customized_courses]
      allow :teachers,[:index,:show,:search,:pass,:unpass,
                       :students,:curriculums,:info,:questions,:topics,:lessons_state,:homeworks,
                       :exercises,:solutions,:customized_tutorial_topics,:notifications,
                       :customized_courses,:profile, :keep_account]
      allow :students,[:index,:search,:show,
                       :info,:teachers,:customized_courses,:homeworks,
                       :solutions,:account,:customized_tutorial_topics,:questions,:notifications]

      allow :customized_courses, [:show,:edit,:update,:teachers,:topics,:homeworks,:solutions, :get_sale_price] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end

      allow :customized_courses ,[:new,:create] do |student|
        user and student
      end


      ## begin live studio permission
      allow 'live_studio/seller/courses', [:index, :show, :new, :create, :edit, :update] do |resource, course, action|
        # seller操作辅导班权限细分
        resource.id == user.id && (course.try(:init?) || %w(index show new create).include?(action))
      end
      ## end live studio permission

      ## 推荐管理
      allow 'recommend/positions', [:index, :show]
      allow 'recommend/teacher_items', [:edit, :destroy, :update]
      allow 'recommend/live_studio_course_items', [:edit, :destroy, :update]
      allow 'recommend/banner_items', [:edit, :destroy, :update]
      allow 'recommend/items', [:new, :create]
      ## 推荐管理

      allow 'payment/users', [:cash]

      allow :schools, [:index, :new, :create]
      allow :schools, [:show, :edit, :update] do |school|
        user.cities.include? school.city
      end

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

      allow 'live_studio/workstation/course_requests', [:accept, :reject] do |owner|
        owner && (owner == user || owner.workstation == user.workstation)
      end
      # 招生请求

      # 开班邀请
      allow 'live_studio/workstation/course_invitations', [:index, :new, :create, :cancel] do |owner|
        owner && (owner == user || owner.workstation == user.workstation)
      end
      # 开班邀请
    end
  end
end
