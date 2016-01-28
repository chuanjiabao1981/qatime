module CourseLibrary
  class ApplicationController < ::ApplicationController
    layout "course_library/application"
    def unauthorized
      redirect_to main_app.root_path
    end
    def current_resource
      if ! params[:teacher_id].nil?
        @teacher = Teacher.find(params[:teacher_id])
      end
    end
  end
end
