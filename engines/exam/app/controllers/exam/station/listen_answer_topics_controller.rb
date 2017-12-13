require_dependency "exam/application_controller"

module Exam
  class Station::ListenAnswerTopicsController < Station::ApplicationController
    before_action :set_group_topic, only: [:edit, :update]

    # GET /station/group_topics/1/edit
    def edit
    end

    # PATCH/PUT /station/group_topics/1
    def update
      if @listen_answer_topic.update(listen_answer_topic_params)
        redirect_to station_workstation_paper_path(@workstation, @listen_answer_topic.paper), notice: 'Group topic was successfully updated.'
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_group_topic
      @listen_answer_topic = Exam::ListenAnswerTopic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listen_answer_topic_params
      params.require(:listen_answer_topic).permit(
        :attach,
        topics_attributes: [
          :title, :answer,
          options_attributes: [:title, :correct]
        ]
      )
    end
  end
end
