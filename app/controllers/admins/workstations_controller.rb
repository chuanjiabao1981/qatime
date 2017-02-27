class Admins::WorkstationsController < ApplicationController

  before_action :worker_station_associations_prepare
  before_action :find_workstation, only: [:edit, :update, :show, :destroy]

  respond_to :html
  layout "admin_home"

  def index
    @workstations = Workstation.all
  end

  def new
    @workstation = Workstation.new
    @workstation.build_coupon
  end

  def create
    @workstation = Workstation.new(params[:workstation].permit!)
    @workstation.build_account
    @workstation.save

    # 这里需要增加短信通知
    respond_with :admins,@workstation
  end

  def show
  end

  def edit
    @workstation.build_coupon if @workstation.coupon.blank?
  end

  def update
    @workstation.update_attributes(params[:workstation].permit!)
    respond_with :admins,@workstation
  end

  def destroy
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

  def find_workstation
    @workstation = Workstation.find_by(id: params[:id])
  end
end
