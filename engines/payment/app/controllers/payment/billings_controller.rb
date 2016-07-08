require_dependency "payment/application_controller"

module Payment
  class BillingsController < ApplicationController

    # GET /billings
    def index
      @billings = @current_resource.billings.includes(change_records: :owner).paginate(page: params[:page])
    end

    private
    def current_resource
      @resource_owner = current_user
      @current_resource = if params[:live_studio_lesson_id]
                            LiveStudio::Lesson.find(params[:live_studio_lesson_id])
                          elsif params[:live_studio_course_id]
                            LiveStudio::Course.find(params[:live_studio_course_id])
                          end
    end
  end
end
