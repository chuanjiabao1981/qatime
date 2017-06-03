class Managers::HomeController < ApplicationController
  respond_to :html
  layout 'v1/manager_home'

  before_action :set_workstation

  def main
  end

  private
  def set_workstation
    if params[:workstation_id]
      @workstation = Workstation.find(params[:workstation_id])
    else
      @workstation = current_user.workstations.first
    end
    @city = @workstation.city
  end

end
