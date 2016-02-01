class Exercise::SameWithTemplate
  def initialize(exercise)
    @exercise = exercise
  end

  def judge?
    return false if @exercise.nil?
    diff = []
    template = @exercise.template
    if template.nil?
      diff << "not exsits"
      return false
    end
    if template.title != @exercise.title
      diff << "title"
    end
    if template.description != @exercise.content
      diff << "description"
    end

    if not same_array?(template.picture_ids,@exercise.template_picture_ids)
      diff << "picture"
    end


    if not same_array?(template.qa_file_ids,@exercise.template_file_ids)
      diff << "files"
    end
    if diff.blank?
      return true
    end
    return false
  end

  private
  def same_array?(a,b)
    a = a || []
    b = b || []
    a.uniq.sort  == b.uniq.sort
  end
end

