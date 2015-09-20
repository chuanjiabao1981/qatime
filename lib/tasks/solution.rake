task :solution => :environment do

  lm
  lp
  we
  wp
  bd
  rp

end

def rp
  homeworks = Homework.where(id:[15])
  homeworks.each do |homework|
    build_s_c(homework)
  end
end
def bd
  homeworks =Homework.where(id:[13])
  homeworks.each do |homework|
    build_s_c(homework)
  end
end

def wp
  homeworks = Homework.where(id:[6,8,17])
  homeworks.each do |homework|
    build_s_c(homework)
  end
end
def we
  homeworks = Homework.where(id:[1])
  homeworks.each do |homework|
    build_s_c(homework)
  end
end
def lp
  homeworks = Homework.where(id:[2,3,10,12,14])
  homeworks.each do |homework|
    build_s_c(homework)
  end
end

def lm
  homeworks = Homework.where(id:[4,5,7,9])
  homeworks.each do |homework|
    build_s_c(homework)
  end

end

def build_s_c(homework)
  homework.topics.each do |topic|
    solution = __build_solution(homework,topic)
    solution.save
    # puts solution.valid?
    # puts solution.errors.full_messages
    # puts solution.to_json(include: :pictures)
    topic.replies.each do |reply|
      if [28,29,44,46,47,65,66].include?(reply.id)
        next
      end
      correction = __build_correction(solution,reply)
      correction.save
      # puts correction.to_json(include: :video)

    end
  end

  homework.topics.each do |topic|
    topic.destroy
  end

end

def __build_solution(homework,topic)
  solution = homework.solutions.build
  solution.token = topic.token
  solution.title = topic.title
  solution.content = topic.content
  solution.student = Student.find(topic.author.id)
  if not topic.author.student?
    puts "fuck 1 fuck 1............................."
  end
  solution.pictures << topic.pictures
  topic.pictures.each do |picture|
    picture.imageable = solution
  end
  solution.created_at = topic.created_at

  if (topic.id == 44)
    comment1 = solution.comments.build
    comment1.author_id = 7
    comment1.content ="鸿鹏同学，请重拍这张，我确实看不清(以后请拍的大点)，另把需要我讲的题号告诉我，以便我即时给你上传。"
    comment1.created_at = Reply.find(44).created_at
    comment2 = solution.comments.build
    comment2.author_id = 280
    comment2.content = "第一张卷子的20题不会，请讲一下"
    comment2.created_at = Reply.find(46).created_at
  end
  if (topic.id == 49)
    comment3 = solution.comments.build
    comment3.author_id = 280
    comment3.content = "这张卷的第16题不清楚为什么。"
    comment3.created_at = Reply.find(47).created_at

  end


  solution
end

def __build_correction(solution,reply)
  correction = solution.corrections.build
  correction.token    = reply.token
  correction.content  = reply.content
  correction.teacher  = Teacher.find(reply.author.id)
  correction.video    = reply.video
  correction.pictures << reply.pictures
  correction.created_at = reply.created_at
  if not reply.author.teacher?
    puts "fuck 2 fuck 2............................."
  end
  if (reply.id == 27)
    comment1 = correction.comments.build
    comment1.author_id = 268
    comment1.content = "老师，语法我一窍不通，你的讲解关于语法的也听不懂，对语法没什么概念，做起来单选题完全不知道从哪里下手，希望老师多费心帮助我，谢谢！"
    comment1.created_at = Reply.find(28).created_at
    comment2 = correction.comments.build
    comment2.author_id = 90
    comment2.content = "不要着急，这份题只是测试一下你的基础，然后我再根据情况制作课程，一步一步来，只要用心学习，就会有进步。"
    comment2.created_at =  Reply.find(29).created_at
  end
  if(reply.id == 60)
    comment4 = correction.comments.build
    comment4.author_id = 70
    comment4.content = "第三题 既然经线没有变化都是相等的，那为什么选D经线长度的变化反映了地球形状的不规则性呢？"
    comment4.created_at = Reply.find(65).created_at
    comment5 = correction.comments.build
    comment5.author_id = 284
    comment5.content="我们说的是理论上是相等的，那么地球是个球体，根据这个题目的数据实际测量的，数据是有变化的，因此体现了不规则性"
    comment5.created_at = Reply.find(66).created_at
  end
  correction
end