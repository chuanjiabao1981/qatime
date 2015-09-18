class Homework < ActiveRecord::Base


  include QaToken
  include ContentValidate

  belongs_to      :customized_course,counter_cache: true
  belongs_to      :teacher
  belongs_to      :student
  has_many        :topics ,as: :topicable,:dependent => :destroy
  has_many        :qa_files, as: :qa_fileable, :dependent => :destroy
  has_many        :pictures,as: :imageable,:dependent => :destroy

  accepts_nested_attributes_for :qa_files, allow_destroy: true

  has_many        :solutions,:dependent =>  :destroy


  scope :by_student ,lambda{|student| where(student_id:student.id).order(created_at: :desc)}
  scope :by_teacher ,lambda{|teacher| where(teacher_id:teacher.id).order(created_at: :desc)}
  def name
    self.title
  end

  def corrections_count
    s = 0
    self.solutions.each do |c|
      if not c.corrections_count.nil?
        s+=c.corrections_count
      end
    end
    s
  end
end
