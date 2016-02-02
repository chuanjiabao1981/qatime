class ExerciseCorrection::BuildFromTemplate
  def initialize(solution,template_id)
    @solution = solution
    @template = CourseLibrary::Solution.find_by_id(template_id)
  end

  def call
    return nil if @solution.nil?
    exercise_solution_correction = @solution.exercise_corrections.build
    return exercise_solution_correction if @template.nil?
    exercise_solution_correction.content            = "#{@template.title}   #{@template.description}"
    exercise_solution_correction.template_video     = @template.video
    exercise_solution_correction.last_operator_id   = @template.homework.course.author_id
    exercise_solution_correction.teacher_id         = exercise_solution_correction.last_operator_id
    exercise_solution_correction.template_id        = @template.id
    exercise_solution_correction
  end
end