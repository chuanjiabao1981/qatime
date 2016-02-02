class CustomizedTutorial::CreateFromTemplate


  def initialize(customized_course_id,template)
    @customized_course_id           = customized_course_id
    @customized_tutorial_template   = template
  end

  def call
    #如果customized_course中已经了有一个customized_tutorial使用此template， 则只同步这个customized_tutorial
    already_tutorials =  CustomizedTutorial.where(customized_course_id: @customized_course_id,
                                                  template_id: @customized_tutorial_template.id)
    if not already_tutorials.blank?
      already_tutorials.each do |t|
        CustomizedTutorial::SyncWithTemplate.new(t).call
      end
      return
    end

    # 没有的话,创建
    a = @customized_tutorial_template.customized_tutorials.build(customized_course_id: @customized_course_id,
                                            title: @customized_tutorial_template.title,
                                            content: @customized_tutorial_template.description,
                                            teacher_id: @customized_tutorial_template.directory.syllabus.author.id,
                                            last_operator_id: @customized_tutorial_template.author_id
    )
    a.template_video        = @customized_tutorial_template.video
    a.template_picture_ids  = @customized_tutorial_template.picture_ids
    a.template_file_ids     = @customized_tutorial_template.qa_file_ids

    a.save
    CustomizedTutorial::CreateExercisesFromTemplate.new(a).call
    a
  end
end