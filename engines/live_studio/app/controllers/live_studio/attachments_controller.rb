require_dependency "live_studio/application_controller"

module LiveStudio
  class AttachmentsController < ApplicationController
    respond_to :json, :js

    def create
      @attachment = Attachment.create(attachment_params)
      respond_to do |format|
        format.json { render json: @attachment }
      end
    end

    private

    def attachment_params
      params.require(:attachment).permit(:file)
    end
  end
end
