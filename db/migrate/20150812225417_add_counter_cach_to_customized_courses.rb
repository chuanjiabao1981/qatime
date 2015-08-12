class AddCounterCachToCustomizedCourses < ActiveRecord::Migration
  def up

    add_column :customized_courses,:customized_tutorials_count_,:integer,default:0
    CustomizedCourse.all.each do |c|
      c.customized_tutorials_count_ = CustomizedTutorial.where(customized_course_id: c.id).size
      c.save
      puts c.reload.customized_tutorials_count_
    end
    rename_column :customized_courses,:customized_tutorials_count_,:customized_tutorials_count
  end

  def down
    remove_column :customized_courses,:customized_tutorials_count

  end
end
