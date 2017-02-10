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
      allow 'recommend/teacher_items', [:new, :create, :edit, :destroy, :update]
      allow 'recommend/live_studio_course_items', [:new, :create, :edit, :destroy, :update]
      allow 'recommend/banner_items', [:new, :create, :edit, :destroy, :update]
      allow 'recommend/items', [:new, :create]
      ## 推荐管理

      allow 'payment/users', [:cash]

      allow :schools, [:index, :new, :create]
      allow :schools, [:show, :edit, :update] do |school|
        user.cities.include? school.city
      end

      allow :curriculums,[:index,:show]
      allow :questions,[:index,:show,:student,:teacher,:teachers]

      # 专属课程
      allow 'station/workstations', [:customized_courses, :schools, :teachers, :students, :sellers, :waiters, :action_records] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 专属课程

      # 辅导班管理
      allow 'live_studio/station/courses', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 辅导班管理

      # 招生请求
      allow 'live_studio/station/course_requests', [:index, :accept, :reject] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 招生请求

      # 开班邀请
      allow 'live_studio/station/course_invitations', [:index, :new, :create, :cancel] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 开班邀请

      allow 'station/lessons', [:state, :update] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

    end
  end
end
