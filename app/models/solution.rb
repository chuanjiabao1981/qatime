class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  include QaHandle
  include QaCommon
  include QaActionRecord
  include QaComment
  include QaCustomizedCourseActionNotification





  belongs_to      :student
  belongs_to      :examination,counter_cache: true
  belongs_to      :first_handle_author,:class_name => "User"
  belongs_to      :last_handle_author,:class => "User"

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
    transition :new                  => :in_progress,       :on => [:correct]
    transition :in_progress          => :completed,         :on => [:complete]
    transition :completed            => :in_progress,       :on => [:redo]
    transition :new                  => :completed,         :on => [:complete]

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
