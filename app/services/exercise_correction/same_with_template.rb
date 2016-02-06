class ExerciseCorrection::SameWithTemplate
  def initialize(exercise_correction)
    @exercise_correction = exercise_correction
  end

  def judge?
    return false if @exercise_correction.nil?
    return false if @exercise_correction.template.nil?
    template = @exercise_correction.template

    diff     = []
    ##juge content and title+description is same

    ##judge material

    CourseLibrary::Util::MaterialDiff.new(@exercise_correction.tempalte,@exercise_correction).call
  end
end