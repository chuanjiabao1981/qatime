class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  include QaHandle
  include QaCommon
  include QaCustomizedCourseActionRecord
  include QaCustomizedCourseStateChangeRecord
  include QaComment


  belongs_to      :student
  belongs_to      :examination,counter_cache: true
  belongs_to      :first_handle_author,:class_name => "User"
  belongs_to      :last_handle_author,:class_name => "User"
  belongs_to      :last_operator,:class_name => "User"

  validates_presence_of :last_operator

  has_many        :corrections,:dependent => :destroy do
    include QaPageNum
    def page_num(o)
      _page_num(o,by: Correction.order_column,order: Correction.order_type,per: Correction.per_page)
    end
  end

  scope           :timeout_to_correct ,lambda {|customized_course_id|
                              where(customized_course_id: customized_course_id)
                                  .where(corrections_count: 0)
                                  .where("created_at <= ?",3.days.ago)
                            }

  scope           :by_customized_course_solution, lambda {where("type = ? or type = ?", HomeworkSolution.to_s,ExerciseSolution.to_s)}


  state_machine :state, initial: :new do
    transition :new                  => :in_progress,       :on => [:handled]
    transition :in_progress          => :completed,         :on => [:complete]
    transition :completed            => :in_progress,       :on => [:redo]
    transition :new                  => :completed,         :on => [:complete]

    after_transition do |solution,transition|

      a = solution.customized_course_state_change_records.build(
                                                            name: :state_change,
                                                            from: transition.from,
                                                            to: transition.to,
                                                            event: transition.event,
                                                            operator_id: solution.last_operator.id
                                                           )
      a.save
    end
  end

  self.per_page = 10

  def author
    self.student
  end

  def operator_id
    self.student_id
  end
  def handles_count
    self.corrections_count
  end


  def set_handle_infos(correction)
    _set_handle_infos correction
  end
  def update_handle_infos
    _update_handle_infos self.corrections
  end





end
