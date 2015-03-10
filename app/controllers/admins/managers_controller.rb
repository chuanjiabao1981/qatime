class Admins::ManagersController < ApplicationController
  layout "admin_home"
  respond_to :html

  def index
    @managers = Manager.all
  end
  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(params[:manager].permit!)
    @manager.save

    respond_with :admins,@manager
  end

  def show
    @manager = Manager.find(params[:id])
  end
end
