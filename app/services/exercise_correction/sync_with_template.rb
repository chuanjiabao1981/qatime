class ExerciseCorrection::SyncWithTemplate
  def initialize(exercise_correction)
    @exercise_correction = exercise_correction
    @template            = exercise_correction.template
  end

  def call
    return if @template.nil?
    @exercise_correction.template_video = @template.video
    @exercise_correction.content        = @template.content

    @exercise_correction.save
  end
end