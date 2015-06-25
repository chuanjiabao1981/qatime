class ChangeVideoTable < ActiveRecord::Migration
  def up
    rename_column :videos,:lesson_id,:videoable_id
    add_column :videos,:videoable_type,:string

    execute <<-SQL
      update videos set videoable_type = 'Lesson'
    SQL
  end

  def down
    rename_column :videos,:videoable_id,:lesson_id
    remove_column :videos,:videoable_type
  end
end
