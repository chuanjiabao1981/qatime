# This migration comes from course_library (originally 20160118223312)
class AddCustomizedTutorialToPublications < ActiveRecord::Migration
  def change
    remove_column    :course_library_publications,:customized_course_id,:integer
    add_column       :course_library_publications,:customized_tutorial_id,:integer
  end
end
