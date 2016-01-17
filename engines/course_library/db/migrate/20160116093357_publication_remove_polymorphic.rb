class PublicationRemovePolymorphic < ActiveRecord::Migration
  def change
    remove_column :course_library_publications,:courseable_id
    remove_column :course_library_publications,:courseable_type
    add_column    :course_library_publications,:customized_course_id,:integer
  end
end
