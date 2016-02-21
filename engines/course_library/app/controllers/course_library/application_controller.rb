module CourseLibrary
  class ApplicationController < ::ApplicationController
    layout 'course_library/layouts/application'
    def unauthorized
      redirect_to main_app.root_path
    end
    def current_resource
      @teacher = Teacher.find(params[:teacher_id])
    end
  end
end
