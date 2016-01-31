class CustomizedTutorial::SyncExercisesWithTemplate
  def initialize(customized_tutorial)
    @customized_tutorial = customized_tutorial
  end

  def call
    @customized_tutorial.exercises.each do |exercise|
      Exercise::SyncWithTemplate.new(exercise).call
      if not exercise.template_id.nil? and not @customized_tutorial.template.has_the_homework?(exercise.template_id)
        #TODO:: 如果模板中已经没有这个作业了，do something
      end
    end
    #把新加的作业也同步过去
    CustomizedTutorial::CreateExercisesFromTemplate.new(@customized_tutorial).call
  end
end