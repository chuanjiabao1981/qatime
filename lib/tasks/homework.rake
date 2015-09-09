task :homework => :environment do
  ww
  lw
  lm
end


def ww
  homework                   = Homework.new
  customized_course          = CustomizedCourse.find(4)
  homework.teacher           = customized_course.teachers.first
  homework.customized_course = customized_course
  homework.title             = "基础测试"
  homework.content           = "这份题只是测试一下你的基础，然后我再根据情况制作课程，一步一步来，只要用心学习，就会有进步。"
  homework.save

  topics = Topic.where(id:[29,30,31,32,33,34,35,36,37])
  topics.each do |t|
    t.topicable = homework
    t.save
  end

end

def lw
  homework                    = Homework.new
  customized_course           = CustomizedCourse.find(2)
  homework.teacher            = customized_course.teachers.first
  homework.customized_course  = customized_course
  homework.title              = "万有引力定律"
  homework.content            = "万有引力定律试卷"
  homework.save
  topic = Topic.find_by_id(26)
  topic.topicable = homework
  topic.save


  homework                    = Homework.new
  customized_course           = CustomizedCourse.find(2)
  homework.teacher            = customized_course.teachers.first
  homework.customized_course  = customized_course
  homework.title              = "物理功和功率"
  homework.content            = "物理功和功率试卷"
  homework.save

  topic = Topic.find_by_id(24)
  topic.topicable = homework
  topic.save


end

def lm
  homework                    = Homework.new
  customized_course           = CustomizedCourse.find(1)
  homework.teacher            = customized_course.teachers.first
  homework.customized_course  = customized_course
  homework.title              = "第一章三角函数"
  homework.content            = "第一章三角函数试卷"
  homework.save

  topic = Topic.find_by_id(25)
  topic.topicable = homework
  topic.save


  homework                    = Homework.new
  customized_course           = CustomizedCourse.find(1)
  homework.teacher            = customized_course.teachers.first
  homework.customized_course  = customized_course
  homework.title              = "第二章等差数列"
  homework.content            = "第二章等差数列练习题"
  homework.save

  topics = Topic.where(id:[20,21,22,23])
  topics.each do |t|
    t.topicable = homework
    t.save
  end

end