class Curriculum < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :teaching_program
  has_many :courses, -> {order 'position'}, :dependent => :destroy
  has_many :lessons

  scope :by_teaching_program,lambda {|s| where(teaching_program_id: s) if s}
  scope :by_subject,lambda {|s| joins(:teaching_program).where({teaching_programs:{subject: s}}) if s}
  scope :by_passed_teacher, lambda{|s| joins(:teacher).where({users:{pass: true}}) if s.nil? or s.teacher? or s.student?}
  accepts_nested_attributes_for :courses

  def get_courses_by_chapter(chapter)
    self.courses.select {|course| course.chapter == chapter}
  end

  def build_course(attributes={})
    a = self.courses.build(attributes)
    a.teacher    = self.teacher
    a.curriculum = self
    a.position   = self.courses_count + 1
    a
  end
end
