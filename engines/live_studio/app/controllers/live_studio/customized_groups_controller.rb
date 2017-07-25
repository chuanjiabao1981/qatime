require_dependency "live_studio/application_controller"

module LiveStudio
  class CustomizedGroupsController < ApplicationController
    before_action :find_workstation, except: [:index, :show]

    def index
    end

    def new
      @customized_group = CustomizedGroup.new(workstation: @workstation, price: nil, teacher_percentage: nil)
      @customized_group.generate_token
      render layout: 'v1/manager_home'
    end

    def create
      @course = Course.new(courses_params.merge(author: current_user))
      @course.taste_count ||= 0
      if @course.save
        LiveService::ChatAccountFromUser.new(@course.teacher).instance_account rescue nil
        redirect_to live_studio.my_courses_station_workstation_courses_path(@course.workstation)
      else
        render :new, layout: 'v1/manager_home'
      end
    end

    def show
    end

    private

    def set_customized_group
      @customized_group = CustomizedGroup.find(params[:id])
    end

    def find_workstation
      if params[:workstation_id].present?
        @workstation = ::Workstation.find(params[:workstation_id])
      end
      @workstation ||= current_user.try(:workstations).try(:first) || current_user.try(:workstation)
    end

    def current_resource
      CustomizedGroup.find(params[:id]) if params[:id]
    end
  end
end
