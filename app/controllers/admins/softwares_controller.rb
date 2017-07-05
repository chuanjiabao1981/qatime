class Admins::SoftwaresController < ApplicationController
  respond_to :html
  def index
    @softwares = Software.all.order(id: :desc)
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
      respond_with :admins, @software
    else
      p @software.errors
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
    @software.published!
    redirect_to action: :index
  end

  # 下架
  def offline
    @software = Software.find params[:id]
    @software.offline!
    redirect_to action: :index
  end

  private

  def software_params
    params.require(:software).permit(:software_category_id, :sub_title, :platform, :version, :role, :category, :desc, :description, :cdn_url, :enforce, :logo, :position)
  end
end
