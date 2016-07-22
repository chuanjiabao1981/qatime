module Permissions
  class ManagerPermission < StaffPermission
    def initialize(user)
      super(user)
      allow :qa_faqs,[:index,:show]

      allow "managers/register_codes",[:index,:create,:new]
      allow "managers/lessons",[:state,:update]

      allow "managers/home",[:main]

      allow :vip_classes,[:show]
      allow :questions,[:index,:show,:student,:teacher,:teachers]
      allow :teaching_videos,[:show]
      allow :students,[:index,:search,:show,:edit,:create,:update,
                       :info,:teachers,:customized_courses,:homeworks,
                       :solutions,:account,:customized_tutorial_topics,:questions,:notifications]
      allow :home,[:index]
      allow :schools,[:index,:new,:create,:show,:edit,:update]
      allow :register_codes, [:index, :new, :downloads, :create]
      allow :teachers,[:index,:new,:create,:show,:edit,:update,:search,:pass,:unpass,
                       :students,:curriculums,:info,:questions,:topics,:lessons_state,:homeworks,
                       :exercises,:keep_account,:solutions,:customized_tutorial_topics,:notifications]
      allow :curriculums,[:index,:show]
      allow :learning_plans,[:new,:teachers,:create,:index,:edit,:update]
      allow :courses,[:show]
      allow :comments,[:create,:show]
      allow :comments,[:edit,:update] do |comment|
        comment
      end

      allow :topics,[:show]
      allow :replies,[:create]
      allow :replies,[:edit,:update,:destroy] do |reply|
        reply and reply.author_id == user.id
      end

      allow :customized_courses, [:show,:edit,:update,:teachers,:topics,:homeworks,:solutions, :get_sale_price] do |customized_course|
        user and customized_course
      end

      allow :customized_courses ,[:new,:create] do |student|
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
      allow :course_issues,[:show]
      allow :course_issue_replies,[:show]
      allow :comments,[:show]
      allow :corrections,[:show]


      allow 'managers/sellers', [:new, :create, :edit, :update, :destroy]
      allow 'managers/waiters', [:new, :create, :edit, :update, :destroy]

      #######begine course library permission###############
      allow "course_library/solutions",[:index, :show]
      allow "course_library/homeworks",[:index, :show]
      allow "course_library/courses",[:index, :show]
      allow "course_library/directories",[:index, :show]
      allow "course_library/syllabuses",[:index, :show]
      #######end course library permission##################

      ## begin live studio permission
      allow 'live_studio/manager/courses', [:index, :show, :new, :create, :edit, :update, :destroy] do |manager,course,action|
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
      allow 'live_studio/student/courses', [:index, :show]
      allow 'live_studio/courses', [:index]
      ## end live studio permission

    end
  end
end
