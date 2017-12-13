require_dependency "exam/application_controller"

module Exam
  class Station::ListenSpeakTopicsController < Station::ApplicationController
    before_action :set_listen_speak_topic, only: [:edit, :update]

    # GET /station/group_topics/1/edit
    def edit
    end

    # PATCH/PUT /station/group_topics/1
    def update
      if @listen_speak_topic.update(listen_speak_topic_params)
        redirect_to station_workstation_paper_path(@workstation, @listen_speak_topic.paper), notice: 'Group topic was successfully updated.'
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_listen_speak_topic
      @listen_speak_topic = Exam::ListenSpeakTopic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listen_speak_topic_params
      params.require(:listen_speak_topic).permit(
        :attach, :title
      )
    end
  end
end
