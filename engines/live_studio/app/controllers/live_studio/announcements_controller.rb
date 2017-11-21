require_dependency "live_studio/application_controller"

module LiveStudio
  class AnnouncementsController < ApplicationController
    layout 'v1/home'

    before_action :set_owner
    before_action :set_course, only: [:index, :create]
    before_action :set_announcement, only: [:update]

    # GET /announcements
    def index
      @announcements = @course.announcements.order(id: :desc).paginate(page: params[:page])
      @announcement = @course.announcements.new
    end

    # POST /announcements
    def create
      @announcement = @course.announcements.new(announcement_params.merge(lastest: true, creator: current_user))

      if @announcement.save
        @course.announcements.where(lastest: true).where("id <> ?", @announcement).update_all(lastest: false)
        redirect_to live_studio.send("#{@course.model_name.singular_route_key}_path", @course),
                    notice: t("activerecord.successful.messages.created", model: LiveStudio::Announcement.model_name.human)
      else
        render :new
      end
    end

    # PATCH/PUT /announcements/1
    def update
      if @announcement.update(announcement_params)
        redirect_to @announcement, notice: 'Announcement was successfully updated.'
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement ||= Announcement.find(params[:id])
    end

    def set_course
      @course ||=
        if params[:course_id].present?
          LiveStudio::Course.find(params[:course_id])
        elsif params[:interactive_course_id].present?
          LiveStudio::InteractiveCourse.find(params[:interactive_course_id])
        else
          LiveStudio::CustomizedGroup.find(params[:customized_group_id])
        end
    end

    def set_owner
      @owner ||= current_user
    end

    # Only allow a trusted parameter "white list" through.
    def announcement_params
      params.require(:announcement).permit(:content)
    end

    def current_resource
      return set_announcement.announcementable if params[:id]
      set_course
    end
  end
end
