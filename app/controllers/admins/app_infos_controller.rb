class Admins::AppInfosController < ApplicationController
  respond_to :html
  def index
    @app_infos = AppInfo.all
  end

  def new
    @app_info = AppInfo.new
  end

  def show
    @app_info = AppInfo.find params[:id]
  end

  def edit
    @app_info = AppInfo.find params[:id]
  end

  def create
    @app_info = AppInfo.new(app_info_params)
    if @app_info.save
      respond_with :admins,@app_info
    else
      render :new
    end
  end

  def update
    @app_info = AppInfo.find params[:id]
    if @app_info.update(app_info_params)
      respond_with :admins,@app_info
    else
      render :edit
    end
  end

  def run
    @app_info = AppInfo.find params[:id]
    @app_info.running!
    redirect_to action: :index
  end

  private
  def app_info_params
    params.require(:app_info).permit(%i(name category version level description download_url enforce enforce_level))
  end
end
