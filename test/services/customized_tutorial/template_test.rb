require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  def setup
    @syllabuses_one          = course_library_syllabuses(:syllabuses_one)
    @directory_one           = course_library_directories(:directory_one)
    @course_one              = course_library_courses(:course_one)
    @customized_course1      = customized_courses(:customized_course1)
    assert @syllabuses_one.valid?
    assert @course_one.valid?
    assert @directory_one.valid?
    assert @customized_course1.valid?
    assert @course_one.qa_files.length != 0
    assert @course_one.pictures.length != 0
    @homework_count                     = @course_one.homeworks.count
    @course_total_files_count           = @course_one.qa_files.count
    @course_total_pictures_count        = @course_one.pictures.count
    @course_one.homeworks.each do |h|
      assert h.valid?
      assert h.qa_files.length    != 0
      @course_total_files_count    = @course_total_files_count + h.qa_files.count
      assert h.pictures.length    != 0
      @course_total_pictures_count = @course_total_pictures_count + h.pictures.count
    end
  end
end