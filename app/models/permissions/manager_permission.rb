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

      allow :students, [:index]
      allow :students, [:search, :show, :edit, :create, :update,
                        :info, :teachers, :customized_courses, :homeworks,
                        :solutions, :account, :customized_tutorial_topics,
                        :questions, :notifications] do |student|
        student.school.blank? ||
          user.city.schools
              .collect { |s| s.students.collect(&:id) }
              .flatten.include?(student.id)
      end

      allow :home, [:index]

      allow :schools, [:index, :show]
      allow :schools, [:new, :create, :edit, :update] do |school|
        user.city_id == school.city_id
      end

      allow :register_codes, [:index, :new, :downloads, :create]

      allow :teachers, [:index]

      allow :teachers, [:new, :create, :show, :edit, :update,
                        :search, :pass, :unpass, :students, :curriculums,
                        :info, :questions, :topics, :lessons_state, :homeworks,
                        :exercises, :keep_account, :solutions,
                        :customized_tutorial_topics, :notifications] do |teacher|
        user.city.schools
            .collect { |s| s.teachers.collect(&:id) }
            .flatten.include?(teacher.id)
      end

      allow :curriculums, [:index, :show]
      allow :learning_plans, [:new, :teachers, :create, :index, :edit, :update]
      allow :courses, [:show]
      allow :comments, [:create, :show]
      allow :comments, [:edit, :update] do |comment|
        comment
      end

      allow :topics,[:show]
      allow :replies,[:create]
      allow :replies,[:edit,:update,:destroy] do |reply|
        reply and reply.author_id == user.id
      end

      allow :customized_courses,
            [:show, :edit, :update, :teachers, :topics,
             :homeworks, :solutions, :get_sale_price] do |customized_course|
        user && customized_course &&
          user.workstations
              .collect { |w| w.customized_courses.collect(&:id) }
              .flatten.include?(customized_course.id)
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
      allow :managers,[:customized_courses,:action_records] do |manager|
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

      #######begine course library permission###############
      allow "course_library/solutions",[:index, :show]
      allow "course_library/homeworks",[:index, :show]
      allow "course_library/courses",[:index, :show]
      allow "course_library/directories",[:index, :show]
      allow "course_library/syllabuses",[:index, :show]
      #######end course library permission##################

    end
  end
end