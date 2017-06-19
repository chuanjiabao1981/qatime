module Permissions
  class SellerPermission < StaffPermission
    def initialize(user)
      super(user)


      allow :questions,[:index,:show,:student,:teacher,:teachers]
      allow :vip_classes,[:show]

      allow :sessions,[:destroy]
      allow :home,[:index,:new_index,:switch_city, :search, :search_teachers, :search_courses, :teachers, :replays, :replay]
      allow "sellers/home", [:main]

      allow :sellers, [:customized_courses]
      allow :teachers,[:index,:show,:search,:pass,:unpass,
                       :students,:curriculums,:info,:questions,:topics,:lessons_state,:homeworks,
                       :exercises,:solutions,:customized_tutorial_topics,:notifications,
                       :customized_courses,:profile, :keep_account]
      allow :students,[:index,:search,:show,
                       :info,:teachers,:customized_courses,:homeworks,
                       :solutions,:account,:customized_tutorial_topics,:questions,:notifications]

      allow :customized_courses, [:show,:edit,:update, :update_desc,:teachers,:topics,:homeworks,:solutions, :get_sale_price, :action_records] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end
      allow :customized_tutorials, [:show]

      allow :customized_courses ,[:new,:create] do |student|
        user and student
      end

      allow :homeworks,[:show] do |homework|
        homework
      end
      allow :solutions,[:show] do |solution|
        solution
      end
      allow :exercises, [:show]

      allow :courses,[:show]
      allow :lessons,[:show]
      allow 'welcome', [:download]

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

      allow 'recommend/station/banner_items', [:index, :new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'recommend/station/topic_items', [:index, :new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'recommend/station/choiceness_items', [:index, :new, :create, :edit, :update, :destroy, :ajax_course_select] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'recommend/station/replay_items', [:index, :new, :create, :edit, :update, :destroy, :ajax_course_select] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'recommend/station/teacher_items', [:index, :new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      ## 推荐管理

      allow 'payment/users', [:cash, :recharges, :withdraws, :consumption_records, :earning_records, :refunds]
      allow 'payment/orders', [:index, :show]

      allow :schools, [:index, :new, :create]
      allow :schools, [:show, :edit, :update] do |school|
        user.cities.include? school.city
      end

      allow :curriculums, [:index, :show]
      allow :learning_plans, [:new, :teachers, :create, :index, :edit, :update]

      allow :tutorial_issues,[:show]
      allow :course_issues, [:show]
      allow :tutorial_issue_replies,[:show]
      allow :course_issue_replies,[:show]
      allow :comments,[:show]
      allow :corrections,[:show]
      allow :notifications, [:index] do |resource_user|
        resource_user && (user.id == resource_user.id || resource_user.student_or_teacher?)
      end

      # 专属课程
      allow 'station/workstations', [:customized_courses, :schools, :teachers, :students, :sellers, :waiters, :action_records, :show, :fund, :change_records, :statistics, :teaching_lessons] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 专属课程

      allow 'station/home', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'station/teachers', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'station/students', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'station/schools', [:index, :new, :create, :edit, :update] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'live_studio/teacher/courses', [:index, :show]
      allow 'live_studio/teacher/course_invitations', [:index]
      allow 'live_studio/student/courses', [:index, :show]

      # 辅导班管理
      allow 'live_studio/station/courses', [:my_courses, :index, :send_qr_code] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'live_studio/station/course_records', [:index, :my_publish]
      allow 'live_studio/teacher/teachers', [:schedules]
      allow 'live_studio/student/students', [:schedules]
      allow 'live_studio/courses', [:schedule_sources, :index, :show, :preview, :play]
      # 辅导班管理

      # 视频课
      allow 'live_studio/station/video_courses', [:index, :my_publish, :my_sells, :audits, :audit, :send_qr_code, :list, :edit, :update, :publish] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'live_studio/station/interactive_courses', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

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

      # 员工
      allow 'station/sellers', [:new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      allow 'station/waiters', [:new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 员工

      allow 'station/lessons', [:state, :update] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'payment/station/workstations', [:show, :earning_records, :withdraws] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'live_studio/interactive_courses', [:index, :show, :preview]
      allow 'live_studio/video_courses', [:index, :show, :preview]
      allow 'live_studio/video_lessons', [:play] do |lesson|
        true
      end

      allow 'payment/station/sale_tasks', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
    end
  end
end
