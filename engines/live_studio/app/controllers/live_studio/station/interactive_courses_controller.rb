require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::InteractiveCoursesController < Station::ApplicationController
    layout 'v1/manager_home'

    def index
      @interactive_courses = @workstation.live_studio_interactive_courses
      @interactive_courses = @interactive_courses.uncompleted if params[:hide_completed].present?
      @query = @interactive_courses.ransack(params[:q])
      @interactive_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def play
      @interactive_course = @workstation.live_studio_interactive_courses.find(params[:id])
      @chat_account = current_user.chat_account
      @chat_team = @interactive_course.chat_team
      @teacher_accounts = @interactive_course.teachers.includes(:chat_account).map(&:chat_account).map(&:accid)
      @members = @chat_team.members_json
      play_check
      render layout: 'manager_page'
    end

    private

    def play_check
      @chat_team = @interactive_course.chat_team
      @chat_account = current_user.chat_account!
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id)
      LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal') unless @join_record
    end
  end
end
