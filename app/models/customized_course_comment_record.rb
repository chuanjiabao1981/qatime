class CustomizedCourseCommentRecord < CustomizedCourseActionRecord
  def desc
    I18n.t "action.comment.create.desc",
           user: self.operator.view_name,what: self.actionable.commentable.model_name.human
  end
end