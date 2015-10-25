class Solution < ActiveRecord::Base
  include QaToken
  include ContentValidate
  include QaHandle
  include QaCommon



  belongs_to      :student

  belongs_to      :examination,counter_cache: true

  has_many        :pictures,as: :imageable
  has_many        :corrections,:dependent => :destroy do
    def page_num(o,options)
      column = options[:by] || :created_at
      order  = options[:order] || :desc
      per    = options[:per] || 5

      operator = (order == :asc ? "<=" : ">=")
      (where("#{column} #{operator} ?", o.send(column)).count.to_f / per).ceil
    end
  end

  has_many        :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy
  has_many        :qa_files, as: :qa_fileable
  accepts_nested_attributes_for :qa_files, allow_destroy: true

  scope :timeout_to_correct ,lambda {|customized_course_id|
                              where(customized_course_id: customized_course_id)
                                  .where(corrections_count: 0)
                                  .where("created_at <= ?",3.days.ago)
                            }

  scope           :by_customized_course_solution, lambda {where("type = ? or type = ?", HomeworkSolution.to_s,ExerciseSolution.to_s)}



  belongs_to :first_handle_author,:class_name => "User"
  belongs_to :last_handle_author,:class => "User"

  self.per_page = 10

  def author
    self.student
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
