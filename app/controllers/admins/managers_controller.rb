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

  def edit
    @manager = Manager.find(params[:id])
  end
  def update
    @manager = Manager.find(params[:id])
    @manager.update_attributes(params[:manager].permit!)
    respond_with :admins,@manager
  end

  def show
    @manager = Manager.find(params[:id])
  end
end
