class WelcomeController < ApplicationController
  layout "application"
  def download
    render && return unless current_user
    @softwares = Software.all
    @softwares = @softwares.where(role: current_user.role) if current_user.student? || current_user.teacher?
  end
end
