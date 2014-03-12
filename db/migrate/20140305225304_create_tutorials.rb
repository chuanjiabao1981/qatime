class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string    :video
      t.string    :cover
      t.string    :title
      t.string    :summary
      t.string    :content
      t.integer   :author_id
      t.integer   :uploader_id
      t.timestamps
    end
  end
end
