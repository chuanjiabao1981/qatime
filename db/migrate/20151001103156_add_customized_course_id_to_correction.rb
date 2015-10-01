class AddCustomizedCourseIdToCorrection < ActiveRecord::Migration
  def change
    add_column :corrections,:customized_course_id,:integer
    Correction.all.each do |c|
      c.customized_course_id = c.solution.customized_course_id
      if  c.customized_course_id.nil?
        puts "add customized_course_id to correction"
      end
      c.save
    end
  end
end
