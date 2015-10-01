class AddCustomizedCourseToSolution < ActiveRecord::Migration
  def change
    add_column :solutions,:customized_course_id,:integer
    Solution.all.each do |s|
      if s.solutionable.instance_of? Exercise
        s.customized_course_id = s.solutionable.customized_tutorial.customized_course_id
        s.save
      end
      if s.solutionable.instance_of? Homework
        s.customized_course_id = s.solutionable.customized_course_id
        s.save
      end
    end
  end
end
