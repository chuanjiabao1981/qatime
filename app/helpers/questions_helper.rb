module QuestionsHelper
  def user_questions_path
    if current_user.student?
      student_questions_path
    elsif current_user.teacher?
      teacher_questions_path
    else
      '#'
    end
  end
end
