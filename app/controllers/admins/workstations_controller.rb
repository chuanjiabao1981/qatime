class Admins::WorkstationsController < ApplicationController
  before_action :worker_station_associations_prepare

  respond_to :html
  layout "admin_home"


  def index
    @workstations = Workstation.all
  end
  def new
    @workstation = Workstation.new
  end

  def create
    @workstation = Workstation.new(params[:workstation].permit!)
    @workstation.build_account
    @workstation.save

    # 这里需要增加短信通知
    respond_with :admins,@workstation
  end

  def show
    @workstation = Workstation.find(params[:id])
  end

  def edit
    @workstation = Workstation.find(params[:id])
  end
  def update
    @workstation = Workstation.find(params[:id])
    @workstation.update_attributes(params[:workstation].permit!)
    respond_with :admins,@workstation
  end
  def destroy
    @workstation = Workstation.find(params[:id])
    @workstation.destroy
    redirect_to admins_workstations_path
  end


  private
  def worker_station_associations_prepare
    unless not @managers.nil?
      @managers = Manager.all
    end

    unless not @cities.nil?
      @cities = City.all
    end
  end
end
