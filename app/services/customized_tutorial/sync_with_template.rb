class CustomizedTutorial::SyncWithTemplate
  def initialize(customized_tutorial)
    @customized_tutorial            = customized_tutorial
    @customized_tutorial_template   = nil
    if not @customized_tutorial.nil?
      @customized_tutorial_template = @customized_tutorial.template
    end
  end

  def call
    return if @customized_tutorial_template.nil?
    @customized_tutorial.title                 = @customized_tutorial_template.title
    @customized_tutorial.content               = @customized_tutorial_template.description
    @customized_tutorial.template_video        = @customized_tutorial_template.video
    @customized_tutorial.template_picture_ids  = @customized_tutorial_template.picture_ids
    @customized_tutorial.template_file_ids     = @customized_tutorial_template.qa_file_ids
    @customized_tutorial.save
    CustomizedTutorial::SyncExercisesWithTemplate.new(@customized_tutorial).call
  end
end