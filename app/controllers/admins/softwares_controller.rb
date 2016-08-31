class Admins::SoftwaresController < ApplicationController
  respond_to :html
  def index
    @softwares = Software.all
  end

  def new
    @software = Software.new
  end

  def show
    @software = Software.find params[:id]
  end

  def edit
    @software = Software.find params[:id]
  end

  def create
    @software = Software.new(software_params)
    if @software.save
      respond_with :admins,@software
    else
      render :new
    end
  end

  def update
    @software = Software.find params[:id]
    if @software.update(software_params)
      respond_with :admins,@software
    else
      render :edit
    end
  end

  def run
    @software = Software.find params[:id]
    @software.running!
    redirect_to action: :index
  end

  private
  def software_params
    params.require(:software).permit(:title, :sub_title, :platform, :version, :role, :desc, :description, :download_links, :enforce,{logo: []})
  end
end
