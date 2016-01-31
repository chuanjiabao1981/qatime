class Exercise::CreateFromTemplate
  def initialize(customized_tutorial,template)
    @customized_tutorial = customized_tutorial
    @exercise_template   = template
  end

  def call
    exercise = @customized_tutorial.exercises.build(customized_course_id: @customized_tutorial.customized_course_id,
                                                     teacher_id:  @exercise_template.course.author_id,
                                                     last_operator_id: @exercise_template.course.author_id,
                                                     title: @exercise_template.title,
                                                     content: @exercise_template.description,
                                                     student_id: @customized_tutorial.customized_course.student.id
    )
    exercise.template               = @exercise_template
    exercise.template_file_ids      = @exercise_template.qa_file_ids
    exercise.template_picture_ids   = @exercise_template.picture_ids
    exercise.save
    exercise
  end
end