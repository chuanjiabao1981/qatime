require_dependency "live_studio/application_controller"

module LiveStudio
  class InteractiveCoursesController < ApplicationController
    layout :current_user_layout

    before_action :find_workstation

    def new
      @interactive_course = InteractiveCourse.new(workstation: @workstation, price: nil, teacher_percentage: nil)
      # 10.times { @interactive_course.interactive_lessons.new }
    end

    def create
      @interactive_course = InteractiveCourse.new(interactive_courses_params)
      @interactive_course.author = current_user
      @interactive_course.taste_count ||= 0
      if @course.save
        # LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to live_studio.station_workstation_interactive_courses_path(@workstation)
      else
        render :new
      end
    end

    # 预览
    def preview
      @course = build_preview_course
      render layout: 'v1/application'
    end


    private

    def find_workstation
      @workstation = current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def interactive_courses_params
      params[:interactive_course][:interactive_lessons_attributes] = params[:interactive_course][:interactive_lessons_attributes].map(&:second) if params[:interactive_course] && params[:interactive_course][:interactive_lessons_attributes]
      params.require(:interactive_course).permit(:name, :grade, :subject, :price, :description, :taste_count, :workstation_id, :publicize, :crop_x, :crop_y, :crop_w, :crop_h,
                                                 interactive_lessons_attributes: [:id, :name, :class_date, :start_time_hour, :start_time_minute, :duration, :_destroy])
    end
  end
end
