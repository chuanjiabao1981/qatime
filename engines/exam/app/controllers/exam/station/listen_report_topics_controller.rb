require_dependency "exam/application_controller"

module Exam
  class Station::ListenReportTopicsController < Station::ApplicationController
    before_action :set_listen_report_topic, only: [:edit, :update]

    # GET /station/group_topics/1/edit
    def edit
    end

    # PATCH/PUT /station/group_topics/1
    def update
      if @listen_report_topic.update(listen_report_topic_params)
        redirect_to @listen_report_topic, notice: 'Group topic was successfully updated.'
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_listen_report_topic
      @listen_report_topic = Exam::ListenReportTopic.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listen_report_topic_params
      params.require(:listen_report_topic).permit(
        :attach,
        topics_attributes: [
          :title, :answer,
          options_attributes: [:title, :correct]
        ]
      )
    end
  end
end
