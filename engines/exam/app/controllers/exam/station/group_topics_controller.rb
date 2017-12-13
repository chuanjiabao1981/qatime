require_dependency "exam/application_controller"

module Exam
  class Station::GroupTopicsController < Station::ApplicationController
    before_action :set_group_topic, only: [:edit, :update]

    # GET /station/group_topics/1/edit
    def edit
    end

    # PATCH/PUT /station/group_topics/1
    def update
      if @group_topic.update(group_topic_params)
        redirect_to station_workstation_paper_path(@workstation, @group_topic.paper), notice: 'Group topic was successfully updated.'
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_group_topic
      @group_topic = Exam::GroupTopic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_topic_params
      params.require(:group_topic).permit(
        :attach,
        topics_attributes: [
          :id, :title, :answer,
          topic_options_attributes: [:id, :title, :correct]
        ]
      )
    end
  end
end
