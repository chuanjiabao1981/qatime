require 'test_helper'

module CourseLibrary
  class SyllabusTest < ActiveSupport::TestCase
    setup do
      #@syllabus = Syllabus.find_by(:title => "syllabuses_one")
      @syllabus = course_library_syllabuses(:syllabuses_one)
      assert_not @syllabus.nil?
      assert_equal "syllabus one title",@syllabus.title
      assert_equal 4,@syllabus.directories.count
    end

    test "get root dir" do
      assert_equal "directory_one",@syllabus.get_root_dir.title
    end

    test "create syllabus" do
      syllabus = Syllabus.new
      syllabus.title = "new syllabus"
      syllabus.description = "description for syllabus"
      assert syllabus.valid?
      assert syllabus.save
    end

    test "create syllabus without title" do
      syllabus = Syllabus.new
      assert_not syllabus.save
    end

    test "update syllabus" do
      @syllabus.update(title:"syllabus one title new")
      assert_not Syllabus.find_by(title:"syllabus one title new").nil?
    end

    test "destroy syllabus" do
      @syllabus.destroy
      assert Syllabus.find_by(title:"syllabus one title new").nil?
    end

  end
end
