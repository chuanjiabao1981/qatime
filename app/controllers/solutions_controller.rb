class SolutionsController < ApplicationController
  layout "application"
  respond_to :html
  include QaFilesHelper
  include QaSolution

  def new
    resource_name               = resource_name_from_params(params)
    @solution                   = build_solution(@examination,resource_name)
  end

  def create
    resource_name               = resource_name_from_params(params)
    @solution                   = build_solution(@examination,resource_name,change_params_for_qa_files(params["#{resource_name}_solution".to_sym]).permit!)
    @solution.student           = current_user
    if @solution.save
      flash[:success]           = "成功提交#{resource_name.camelize.constantize.model_name.human}"
    end
    respond_with @examination,@solution
  end

  def show
    @correction   = @solution.send("#{@solution.examination.model_name.singular_route_key}_corrections").build
    solution_show_prepare
  end


  def edit

  end

  def update
    resource_name               = @solution.examination.model_name.singular_route_key
    if @solution.update_attributes(change_params_for_qa_files(params["#{resource_name}_solution".to_sym]).permit!)
      flash[:success] = "成功修改#{Solution.model_name.human}"
    end
    respond_with  @solution
  end
  def destroy
    @solution.destroy
    @examination      = @solution.container
    respond_with @examination
  end
  private
  def current_resource
    r                     = container_resource(params)
    @examination          = r
    if params[:id]
      @solution           = Solution.find(params[:id])
      r                   = @solution
      @examination  = @solution.examination
    end
    r
  end

end
