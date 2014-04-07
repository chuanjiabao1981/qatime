class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string      :name
      t.text        :desc
      t.integer     :section_id
      t.integer     :node_id
      t.integer     :lessons_count,default:0
      t.integer     :author_id
      t.string      :token
      t.timestamps
    end
  end
end
