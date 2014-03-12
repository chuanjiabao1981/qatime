class Cpanel::SectionsController < Cpanel::ApplicationController
  def index
    @sections = Section.all
  end
  def new
    @section  = Section.new
  end
  def create
    @section = Section.new(params[:section].permit!)
    if @section.save
      redirect_to(cpanel_sections_path, :notice => 'Section was successfully created.')
    else
      render :action => "new"
    end
  end
  def edit
    @section = Section.find(params[:id])
  end
  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section].permit!)
      redirect_to cpanel_sections_path,:notice => 'Section was successfully updated.'
    else
      render "edit"
    end
  end
  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    redirect_to cpanel_sections_path
  end
end
