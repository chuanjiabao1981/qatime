class CorrectionsController < ApplicationController
  layout "application"
  include QaSolution

  respond_to :html

  def create
    resource_name         = @solution.examination.model_name.singular_route_key
    @correction           = build_correction(@solution,resource_name,params["#{resource_name}_correction".to_sym].permit!)
    @correction.teacher   = current_user
    if @correction.save
      flash[:success] = "成功创建了#{@correction.model_name.human}"
      redirect_to solution_path(@solution)
    else
      solution_show_prepare
      render 'solutions/show'
    end

  end

  def show
    page_num = @solution.corrections.page_num(@correction)
    redirect_to solution_path(@solution,page: page_num,
                              "#{@correction.model_name.singular_route_key}_animate": @correction.id,
                              anchor: "#{@correction.model_name.singular_route_key}_#{@correction.id}")
  end

  def edit

  end

  def update
    resource_name         = @solution.examination.model_name.singular_route_key
    if @correction.update_attributes(params["#{resource_name}_correction".to_sym].permit!)
      flash[:success] = "成功编辑了#{@correction.model_name.human}"
      redirect_to solution_path(@correction.solution)
    else
      render 'edit'
    end
  end

  def destroy
    @correction.destroy
    respond_with @correction.solution
  end

  private
  def current_resource
    r                     = container_resource(params)
    @solution             = r
    if params[:id]
      @correction = Correction.find(params[:id])
      @solution   = @correction.solution
      r = @correction
    end
    r
  end
end
