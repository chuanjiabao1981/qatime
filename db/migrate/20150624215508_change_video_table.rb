class ChangeVideoTable < ActiveRecord::Migration
  def up
    rename_column :videos,:lesson_id,:videoable_id
    add_column :videos,:videoable_type,:string
    add_column :videos,:author_id,:integer
    execute <<-SQL
      update videos set videoable_type = 'Lesson'
    SQL
    Video.all.each do |v|
      if v.videoable and v.videoable.teacher
        v.author_id = v.videoable.teacher.id
        v.save
      end
    end

  end

  def down
    rename_column :videos,:videoable_id,:lesson_id
    remove_column :videos,:videoable_type
    remove_column :videos,:author_id,:integer

  end
end
