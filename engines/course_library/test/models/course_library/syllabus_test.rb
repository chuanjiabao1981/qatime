require 'test_helper'

module CourseLibrary
  class SyllabusTest < ActiveSupport::TestCase
    test "create syllabus" do
      syllabus = Syllabus.new
      syllabus.title = "new syllabus"
      syllabus.description = "description for syllabus"
      assert syllabus.valid?
      assert Directory.find_by(title: syllabus.title).nil?
    end
  end
end
