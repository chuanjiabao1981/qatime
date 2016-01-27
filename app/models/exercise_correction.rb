class ExerciseCorrection < Correction
  include Tally


  belongs_to :exercise_solution,foreign_key: :solution_id
  belongs_to :exercise,foreign_key: :examination_id
  belongs_to :customized_course
  belongs_to :customized_tutorial
  belongs_to :template, class_name: CourseLibrary::Solution

  has_one    :video_quoter,as: :file_quoter
  has_one    :template_video,through: :video_quoter,source: :video

  def template_id=(template_id)
    super(template_id)
    template = CourseLibrary::Solution.find_by_id(template_id)
    return unless template
    self.content            = "#{template.title}   #{template.description}"
    self.template_video     = template.video
    self.last_operator_id   = template.homework.course.author_id
    self.teacher_id         = self.last_operator_id
  end

end