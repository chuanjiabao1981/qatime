class Curriculum < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :teaching_program
  has_many :courses
  has_many :lessons

  def get_courses_by_chapter(chapter)
    self.courses.select {|course| course.chapter == chapter}
  end

  def build_course(attributes={})
    a = self.courses.build(attributes)
    a.teacher    = self.teacher
    a.curriculum = self
    a
  end
end
