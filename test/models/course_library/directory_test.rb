require 'test_helper'

module CourseLibrary
  class DirectoryTest < ActiveSupport::TestCase
    setup do
      @directory = course_library_directories(:directory_one)
      assert_not @directory.nil?
      assert_equal "directory_one",@directory.title
    end

    test "get full path" do
      assert_equal 3,Directory.find_by(:title => "section1").get_full_path.count
    end

    test "create directory" do
      directory = Directory.new
      directory.title = "new directory"
      assert directory.valid?
      assert directory.save
    end

    test "update directory" do
      @directory.update(title:"directory_one new")
      assert_not Directory.find_by(title:"directory_one new").nil?
    end

    test "destroy directory" do
      @directory.destroy
      assert Directory.find_by(title:"directory_one new").nil?
    end

  end
end
