class Admins::SoftwareCategoriesController < ApplicationController
  respond_to :html
  before_action :find_software_category, only: [:edit, :update, :show]

  def index
    @software_categories = SoftwareCategory.order(:id)
  end

  def new
    @software_category = SoftwareCategory.new
  end

  def show
  end

  def edit
  end

  def create
    @software_category = SoftwareCategory.new(software_category_params)
    if @software_category.save
      respond_with :admins, @software_category
    else
      render :new
    end
  end

  def update
    if @software_category.update(software_category_params)
      respond_with :admins, @software_category
    else
      render :edit
    end
  end

  private

  def find_software_category
    @software_category = SoftwareCategory.find params[:id]
  end

  def software_category_params
    params.require(:software_category).permit(:title, :sub_title, :platform, :role, :category, :desc, :download_description, :logo)
  end
end
