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

    @exercise.solutions.each do |solution|
      solution.corrections.each do |correction|
        if not correction.template.nil?
          ExerciseCorrection::SyncWithTemplate.new(correction).call
        end
      end
    end
  end
end