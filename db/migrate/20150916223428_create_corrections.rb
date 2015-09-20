class CreateCorrections < ActiveRecord::Migration
  def change
    create_table :corrections do |t|
      t.text :content
      t.integer :teacher_id
      t.integer :solution_id
      t.string :token

      t.timestamps null: false
    end
    add_column :homeworks, :solutions_count,:integer,:default=>0

  end

end
