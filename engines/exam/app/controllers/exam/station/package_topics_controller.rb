require_dependency "exam/application_controller"

module Exam
  class Station::PackageTopicsController < Station::ApplicationController
    before_action :set_package_topic, only: [:edit, :update]

    # GET /station/group_topics/1/edit
    def edit
    end

    # PATCH/PUT /station/group_topics/1
    def update
      if @package_topic.update(package_topic_params)
        redirect_to station_workstation_paper_path(@workstation, @package_topic.paper), notice: 'Group topic was successfully updated.'
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_package_topic
      @package_topic = Exam::PackageTopic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def package_topic_params
      params.require(:package_topic).permit(
        :attach,
        topics_attributes: [
          :id, :title, :answer_attach,
          topics_attributes: [:id, :answer]
        ]
      )
    end
  end
end
