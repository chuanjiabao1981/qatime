class CustomizedTutorial::SameWithTemplate
  def initialize(customized_tutorial)
    @customized_tutorial = customized_tutorial
  end

  def judge?
    return false if @customized_tutorial.nil?
    diff = []
    template = @customized_tutorial.template

    if template.nil?
      diff << "not exsits"
    end

    if @customized_tutorial.title != template.title
      diff << "title"
    end



    if @customized_tutorial.content != template.description
      diff << "description"
    end


    m_diff   =
        CourseLibrary::Util::MaterialDiff.new(template,@customized_tutorial).call

    diff     = diff + m_diff

    if not same_array?(exercise_template_ids,template.homework_ids)
      diff << "exercises"
    end

    @customized_tutorial.exercises.each do |exercise|
      #只对有template的exercise 判断是否相同
      if not exercise.template.nil? and not Exercise::SameWithTemplate.new(exercise).judge?
        diff << "exercise #{exercise.id}"
      end
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
  def exercise_template_ids
    @customized_tutorial.exercises.map {|x| x.template_id}.compact
  end
end
