module CourseLibrary
  class Course::UnPublish
    def initialize(customized_tutorial_id)
      @customized_tutorial = CustomizedTutorial.find_by_id(customized_tutorial_id)
    end

    def call
      return false if @customized_tutorial.nil? or
          CustomizedTutorial::AnyComponentCharged.new(@customized_tutorial).judge?
      @customized_tutorial.destroy
      return true
    end
  end
end