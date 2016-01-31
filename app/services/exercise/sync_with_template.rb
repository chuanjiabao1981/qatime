class Exercise::SyncWithTemplate
  def initialize(exercise)
    @exercise = exercise
  end

  def call
    return if @exercise.nil? or @exercise.template.nil?
    @exercise.title                  =   @exercise.template.title
    @exercise.content                =   @exercise.template.description
    @exercise.template_file_ids      =   @exercise.template.qa_file_ids
    @exercise.template_picture_ids   =   @exercise.template.picture_ids
    @exercise.save
  end
end