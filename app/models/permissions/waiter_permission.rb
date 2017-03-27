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

      allow :customized_courses, [:show,:edit,:update,:teachers,:topics,:homeworks,:solutions, :get_sale_price, :action_records] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end
      allow :customized_tutorials, [:show]

      allow :homeworks,[:show] do |homework|
        homework
      end
      allow :solutions,[:show] do |solution|
        solution
      end
      allow :exercises, [:show]

      allow :customized_courses, [:new, :create, :get_sale_price, :teachers]

      allow :curriculums,[:index,:show]
      allow :questions,[:index,:show,:student,:teacher,:teachers]
      allow :vip_classes,[:show]

      allow :schools, [:index]

      allow :tutorial_issues,[:show]
      allow :course_issues, [:show]
      allow :tutorial_issue_replies,[:show]
      allow :course_issue_replies,[:show]
      allow :comments,[:show]
      allow :corrections,[:show]
      allow :notifications, [:index] do |resource_user|
        resource_user && (user.id == resource_user.id || resource_user.student_or_teacher?)
      end
      allow 'welcome', [:download]

      allow 'recommend/positions', [:index, :show]
      allow 'payment/users', [:cash]
      allow 'payment/orders', [:index, :show]

      allow :courses,[:show]
      allow :lessons,[:show]

      # 专属课程
      allow 'station/workstations', [:customized_courses, :schools, :teachers, :students, :sellers, :waiters, :action_records] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 专属课程

      allow 'station/teachers', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'station/students', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'live_studio/teacher/courses', [:index, :show]
      allow 'live_studio/teacher/course_invitations', [:index]
      allow 'live_studio/student/courses', [:index, :show]

      # 辅导班管理
      allow 'live_studio/station/courses', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end

      allow 'live_studio/teacher/teachers', [:schedules]
      allow 'live_studio/student/students', [:schedules]
      allow 'live_studio/courses', [:schedule_sources]
      # 辅导班管理

      # 招生请求
      allow 'live_studio/station/course_requests', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 招生请求

      # 开班邀请
      allow 'live_studio/station/course_invitations', [:index] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
      # 开班邀请

      allow 'station/lessons', [:state, :update] do |workstation|
        workstation && workstation.id == user.workstation_id
      end
    end
  end
end
