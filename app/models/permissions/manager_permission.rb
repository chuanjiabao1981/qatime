module Permissions
  class ManagerPermission < StaffPermission
    def initialize(user)
      super(user)
      allow :qa_faqs,[:index,:show,:static_page, :agreements, :agreement, :teacher_usages, :teacher_usage, :student_usages, :student_usage]

      allow "managers/register_codes",[:index,:create,:new]
      allow "managers/lessons",[:state,:update]

      allow "managers/home",[:main]

      allow :pictures,[:new,:create]
      allow :pictures,[:destroy] do |picture|
        picture and picture.author and picture.author_id == user.id
      end

      allow :vip_classes,[:show]
      allow :questions,[:index,:show,:student,:teacher,:teachers]
      allow :teaching_videos,[:show]
      allow :students,[:index,:search,:show, :edit, :update,
                       :info,:teachers,:customized_courses,:homeworks,
                       :solutions,:account,:customized_tutorial_topics,:questions,:notifications]

      allow :home,[:index,:new_index,:switch_city, :search, :search_teachers, :search_courses, :teachers, :replays, :replay]
      allow :schools,[:index,:new,:create]
      allow :schools,[:show,:edit,:update] do |school|
        user.cities.include? school.city
      end
      allow :register_codes, [:index, :new, :downloads, :create]
      allow :teachers,[:index,:show,:search,:pass,:unpass, :edit, :update,
                       :students,:curriculums,:info,:questions,:topics,:lessons_state,:homeworks,
                       :exercises, :keep_account, :solutions,:customized_tutorial_topics,:notifications,
                       :customized_courses,:profile]
      allow :curriculums,[:index,:show]
      allow :learning_plans,[:new,:teachers,:create,:index,:edit,:update]
      allow :courses,[:show]
      allow :lessons,[:show]
      allow :comments,[:create,:show]
      allow :comments,[:edit,:update] do |comment|
        comment
      end

      allow :topics,[:show]
      allow :replies,[:create]
      allow :replies,[:edit,:update,:destroy] do |reply|
        reply and reply.author_id == user.id
      end

      allow :customized_courses, [:show,:edit,:update, :update_desc,:teachers,:topics,:homeworks,:solutions,:action_records] do |customized_course|
        user && customized_course && user.customized_courses.include?(customized_course)
      end

      allow :customized_courses ,[:new,:create,:get_sale_price,:teachers] do |student|
        user and student
      end

      allow :customized_tutorials, [:show]
      allow :homeworks,[:show] do |homework|
        homework
      end
      allow :solutions,[:show] do |solution|
        solution
      end

      allow :managers,[:payment]
      allow :managers,[:customized_courses,:action_records, :waiters, :sellers] do |manager|
        manager.id == user.id
      end
      # 专属课程
      allow 'station/workstations', [:customized_courses, :schools, :teachers, :students, :sellers, :waiters, :action_records, :show, :fund, :withdraw, :change_records, :statistics, :teaching_lessons] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      # 专属课程

      allow 'station/home', [:index] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'station/teachers', [:index] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow 'station/students', [:index] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow 'station/schools', [:index, :new, :create, :edit, :update] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow :exercises,[:show]
      allow :sessions,[:destroy]

      allow :deposits,[:new,:create] do |account|
        account and account.accountable.student?
      end
      allow :withdraws,[:new,:create] do |account|
        account and account.accountable.teacher?
      end

      allow :tutorial_issues,[:show]
      allow :course_issues, [:show]
      allow :tutorial_issue_replies,[:show]
      allow :course_issue_replies,[:show]
      allow :comments,[:show]
      allow :corrections,[:show]
      allow :notifications, [:index] do |resource_user|
        resource_user && (user.id == resource_user.id || resource_user.student_or_teacher?)
      end

      #######begine course library permission###############
      # allow "course_library/solutions",[:index, :show]
      # allow "course_library/homeworks",[:index, :show]
      # allow "course_library/courses",[:index, :show]
      # allow "course_library/directories",[:index, :show]
      # allow "course_library/syllabuses",[:index, :show]
      #######end course library permission##################


      ## begin recommend permission
      allow 'recommend/positions', [:index, :show]
      allow 'recommend/teacher_items', [:index, :new, :create, :edit, :destroy, :update]
      allow 'recommend/live_studio_course_items', [:new, :create, :edit, :destroy, :update]
      allow 'recommend/banner_items', [:index, :new, :create, :edit, :destroy, :update]
      allow 'recommend/choiceness_items', [:index, :new, :create, :edit, :destroy, :update, :ajax_course_select]
      allow 'recommend/items', [:new, :create]

      allow 'recommend/station/banner_items', [:index, :new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'recommend/station/topic_items', [:index, :new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'recommend/station/choiceness_items', [:index, :new, :create, :edit, :update, :destroy, :ajax_course_select] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'recommend/station/replay_items', [:index, :new, :create, :edit, :update, :destroy, :ajax_course_select] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'recommend/station/teacher_items', [:index, :new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      ## end   recommend permission

      ## begin live studio permission
      allow 'live_studio/manager/courses', [:index, :show, :new, :create, :edit, :update, :destroy] do |manager, course,action|
        # manager操作辅导班权限细分
        # 根据辅导班状态
        # 初始化: 增删改查
        # 招生中: 查删(条件:无购买记录)
        # 已开课: 查删(条件:同上)
        # 已完成: 查
        permission =
            case course.try(:status)
              when 'init'
                true
              when 'preview','teaching'
                action == 'show' || (action == 'destroy' && course.tickets.blank?)
              when 'completed'
                action == 'show'
              when nil
                true
              else
                false
            end
        manager == user && permission
      end
      allow 'live_studio/teacher/courses', [:index, :show]
      allow 'live_studio/teacher/customized_groups', [:index]
      allow 'live_studio/student/customized_groups', [:index]
      allow 'live_studio/student/courses', [:index, :show]
      allow 'live_studio/manager/course_invitations', [:index, :new, :create, :cancel]
      allow 'live_studio/manager/course_requests', [:index, :accept, :reject]
      allow 'live_studio/station/course_records', [:index, :my_publish]
      allow 'live_studio/courses', [:index, :new, :create, :show, :preview, :play]
      allow 'live_studio/courses', [:edit, :update, :destroy] do |course|
        permission =
          case course.try(:status)
            when 'init'
              true
            when 'preview','teaching'
              action == 'show' || (action == 'destroy' && course.tickets.blank?)
            when 'completed'
              action == 'show'
            when nil
              true
            else
              false
          end
        user.workstations.map(&:id).include?(course.workstation_id) && permission
      end

      allow 'live_studio/courses', [:update_class_date, :update_lessons] do |course|
        permission = %w[init published teaching].include? course.try(:status)
        course && permission && ( course.author_id == user.id || user.workstation_ids.include?(course.workstation_id) )
      end
      allow 'live_studio/interactive_courses', [:index, :new, :create, :show, :preview]
      allow 'live_studio/interactive_courses', [:update_class_date, :update_lessons] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow 'live_studio/customized_groups', [:index, :show, :preview]
      allow 'live_studio/station/customized_groups', [:new, :create]
      allow 'live_studio/station/customized_groups', [:index, :update_class_date, :update_lessons] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow 'live_studio/video_courses', [:index, :show, :preview, :edit, :update]
      allow 'live_studio/video_lessons', [:play] do |lesson|
        true
      end

      ## end live studio permission
      allow 'chat/teams', [:finish, :members, :member_visit]
      allow 'welcome', [:download]
      allow 'payment/users', [:cash, :recharges, :withdraws, :consumption_records, :earning_records, :refunds]
      allow 'payment/orders', [:index, :show]

      allow 'live_studio/station/courses', [:my_courses, :index, :send_qr_code] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'live_studio/station/interactive_courses', [:index] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'live_studio/station/video_courses', [:index, :my_publish, :my_sells, :audits, :audit, :send_qr_code, :list, :edit, :update, :publish] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'live_studio/teacher/teachers', [:schedules]
      allow 'live_studio/student/students', [:schedules]
      allow 'live_studio/courses', [:schedule_sources]

      # 招生请求
      allow 'live_studio/station/course_requests', [:index, :accept, :reject] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      # 招生请求

      # 开班邀请
      allow 'live_studio/station/course_invitations', [:index, :new, :create, :cancel] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      # 开班邀请

      # 员工
      allow 'station/sellers', [:new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      allow 'station/waiters', [:new, :create, :edit, :update, :destroy] do |workstation|
        workstation && workstation.manager_id == user.id
      end
      # 员工

      allow 'station/lessons', [:state, :update] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow 'payment/station/workstations', [:show, :earning_records, :withdraws] do |workstation|
        workstation && workstation.manager_id == user.id
      end

      allow 'payment/station/sale_tasks', [:index] do |workstation|
        workstation && workstation.manager_id == user.id
      end
    end
  end
end
