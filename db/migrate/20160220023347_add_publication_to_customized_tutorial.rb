class AddPublicationToCustomizedTutorial < ActiveRecord::Migration
  def change
    add_column :customized_tutorials,:course_publication_id,:integer
  end
end
