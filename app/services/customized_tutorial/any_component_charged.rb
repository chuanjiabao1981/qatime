class CustomizedTutorial::AnyComponentCharged
  def initialize(customized_tutorial)
    @customized_tutorial = customized_tutorial
  end

  def judge?
    return true if @customized_tutorial.is_charged?
    @customized_tutorial.exercises.each do |e|
      return true if Exercise::AnyComponentCharged.new(e).judge?
    end

    @customized_tutorial.tutorial_issues.each do |ti|
      return true if TutorialIssue::AnyComponentCharged.new(ti).judge?
    end

    return false
  end
end