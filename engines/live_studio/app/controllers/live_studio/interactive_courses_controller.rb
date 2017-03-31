require_dependency "live_studio/application_controller"

module LiveStudio
  class InteractiveCoursesController < ApplicationController
    layout :current_user_layout

    before_action :find_workstation
    before_action :find_interactive_course, only: [:destroy, :preview, :update_class_date, :update_lessons]

    def new
      @interactive_course = InteractiveCourse.new(workstation: @workstation, price: nil, teacher_percentage: nil)
      10.times { @interactive_course.interactive_lessons.new }
    end

    def create
      @interactive_course = InteractiveCourse.new(interactive_courses_params)
      @interactive_course.author = current_user
      if @interactive_course.save
        # LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to live_studio.station_workstation_interactive_courses_path(@workstation)
      else
        render :new
      end
    end

    def destroy
      if @interactive_course.init?
        @interactive_course.destroy
      end
      redirect_to live_studio.station_workstation_interactive_courses_path(@workstation)
    end

    # 预览
    def preview
      @course = build_preview_course
      render layout: 'v1/application'
    end

    # 调课
    def update_class_date
    end

    def update_lessons
      # 课程更新 全部更新时间戳 render error时可以重新编辑
      @interactive_course.interactive_lessons.map(&:touch)
      if @interactive_course.update(interactive_lessons_params)
        redirect_to live_studio.station_workstation_interactive_courses_path(@workstation)
      else
        render :update_class_date
      end
    end

    private

    def find_workstation
      @workstation ||= current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def current_resource
      find_workstation
    end

    def find_interactive_course
      @interactive_course = InteractiveCourse.find(params[:id])
    end

    def interactive_courses_params
      params.require(:interactive_course).permit(:name, :grade, :subject, :price, :teacher_percentage, :description, :objective, :suit_crowd, :taste_count, :workstation_id, :publicize, :crop_x, :crop_y, :crop_w, :crop_h,
                                                 interactive_lessons_attributes: [:id, :name, :class_date, :teacher_id, :start_time_hour, :start_time_minute, :duration, :_destroy])
    end

    def interactive_lessons_params
      params.require(:interactive_course).permit(interactive_lessons_attributes: [:id, :duration, :class_date, :teacher_id, :start_time_hour, :start_time_minute, :_update])
    end
  end
end
