require_dependency "chat/application_controller"

module Chat
  class TeamsController < ApplicationController
    def finish
      @course = LiveStudio::Course.find(params[:live_studio_course_id])
      # 当前用户没有云信ID创建云信ID
      @chat_account = current_user.chat_account
      @chat_account ||= LiveService::ChatAccountFromUser.new(current_user).instance_account
      # 如果没有team创建team
      @chat_team = @course.chat_team
      @chat_team ||= LiveService::ChatTeamManager.new(@chat_team).instance_team(@course, @course.teacher.chat_account)
      # 当前用户没有加入群组立即加入群组
      @join_record = @chat_team.join_records.find_by(account_id: @chat_account.id)
      @join_record ||= LiveService::ChatTeamManager.new(@chat_team).add_to_team([@chat_account], 'normal')


      p '==========>>>>>'
      p { team_id: @chat_team.team_id, token: @chat_account.token, accid: @chat_account.accid }
      render json: { team_id: @chat_team.team_id, token: @chat_account.token, accid: @chat_account.accid }
    end

    # 返回群成员列表
    def members
      chat_team = Chat::Team.find_by(team_id: params[:live_studio_course_id])
      @accounts = chat_team.try(:accounts)
      if !@accounts.blank?
        top = Account.find_by(accid: chat_team.owner)
        @accounts = @accounts.reject{|a| a.accid == top.accid}.sort_by(&:name).unshift(top)
      end
      render partial: 'live_studio/courses/members'
    end
  end
end
