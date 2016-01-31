class CustomizedTutorial::CreateExercisesFromTemplate
  def initialize(customized_tutorial)
    @customized_tutorial = customized_tutorial
  end

  def call
    return if @customized_tutorial.template.nil?
    already_published_homework    = []
    @customized_tutorial.exercises.each do |e|
      if e.template
        already_published_homework << e.template.id
        Exercise::SyncWithTemplate.new(e).call
      end
    end
    @customized_tutorial.template.homeworks.each do |homework|
      if not already_published_homework.include?(homework.id)
        Exercise::CreateFromTemplate.new(@customized_tutorial,homework).call
      end
    end
  end
end