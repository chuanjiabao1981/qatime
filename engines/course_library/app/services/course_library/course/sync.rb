module CourseLibrary
  class Course::Sync
    def initialize(customized_tutorial_id)
      @customized_tutorial = CustomizedTutorial.find_by_id(customized_tutorial_id)
    end

    def call
      return false if @customized_tutorial.nil? or CustomizedTutorial::AnyComponentCharged.new(@customized_tutorial).judge?
      # customized_tutorial.sync_with_template
      CustomizedTutorial::SyncWithTemplate.new(@customized_tutorial).call
      return true
    end
  end
end