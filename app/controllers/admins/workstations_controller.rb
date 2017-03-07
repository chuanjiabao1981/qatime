class Admins::WorkstationsController < ApplicationController

  before_action :find_workstation, only: [:edit, :update, :show, :destroy, :change_status]

  respond_to :html
  layout "admin_home"

  def index
    @workstations = Workstation.order(id: :desc).paginate(page: params[:page])
  end

  def new
    @workstation = Workstation.new
    @workstation.build_coupon
  end

  def create
    @workstation = Workstation.new(workstation_params)
    @workstation.build_account
    if @workstation.save
      flash_msg(:success)
      redirect_to admins_workstations_path
    else
      flash_msg(:danger)
      render :new
    end
    # 这里需要增加短信通知
  end

  def show
  end

  def edit
    @workstation.build_coupon if @workstation.coupon.blank?
  end

  def update
    if @workstation.update_attributes(workstation_params)
      flash_msg(:success)
      redirect_to admins_workstation_path(@workstation)
    else
      flash_msg(:danger)
      render :edit
    end
  end

  def destroy
    @workstation.destroy
    redirect_to admins_workstations_path
  end

  def change_status
    @workstation.may_run? ? @workstation.run! : @workstation.stop!

    respond_to do |format|
      format.html {}
      format.js {
        render js: "window.location.reload();"
      }
    end
  end

  private

  def find_workstation
    @workstation = Workstation.find(params[:id])
  end

  def workstation_params
    params.require(:workstation).permit!
  end
end
