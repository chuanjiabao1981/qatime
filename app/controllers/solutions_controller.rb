class SolutionsController < ApplicationController
  layout "application"
  respond_to :html
  include QaFilesHelper
  include QaSolution

  def new
    resource_name               = resource_name_from_params(params)
    @solution                   = build_solution(@solutionable,resource_name)
  end

  def create
    resource_name               = resource_name_from_params(params)
    @solution                   = build_solution(@solutionable,resource_name,change_params_for_qa_files(params["#{resource_name}_solution".to_sym]).permit!)
    @solution.student           = current_user
    if @solution.save
      flash[:success]           = "成功创建#{Solution.model_name.human}"
      @solution.notify
    end
    respond_with @solutionable,@solution
  end

  def show
    @correction = Correction.new
    @corrections = @solution.corrections.order(:created_at => :desc).paginate(page: params[:page])
    @qa_files   = @solution.qa_files.order(:created_at => "ASC")

  end


  def edit

  end

  def update
    resource_name               = @solution.container.model_name.singular_route_key
    if @solution.update_attributes(change_params_for_qa_files(params["#{resource_name}_solution".to_sym]).permit!)
      flash[:success] = "成功修改#{Solution.model_name.human}"
    end
    respond_with  @solution
  end
  def destroy
    @solution.destroy
    @solutionable = @solution.solutionable
    respond_with @solutionable
  end
  private
  def current_resource
    r               = solution_container_resource(params)
    @solutionable   = r
    if params[:id]
      @solution     = Solution.find(params[:id])
      r             = @solution
      @solutionable = @solution.solutionable
    end
    r
  end

end
