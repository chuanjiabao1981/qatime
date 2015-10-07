class AddCutomizedCourseToTopicAndReply < ActiveRecord::Migration
  def change
    add_column :topics,:customized_course_id,:integer
    add_column :replies,:customized_course_id,:integer
    Topic.all.each do |t|
      if t.topicable.instance_of? CustomizedTutorial
        t.customized_course_id = t.topicable.customized_course_id
        puts "Topic Tutorial:#{t.title}"
        t.save
      elsif t.topicable.instance_of? CustomizedCourse
        t.customized_course_id = t.topicable_id
        puts "Topic CustomizedCourse:#{t.title}"
        t.save
      end
      if not t.customized_course_id.nil?
        t.replies.each do |r|
          r.customized_course_id = t.customized_course_id
          puts "Topic reply "
          r.save
        end
      end
    end
  end
end
