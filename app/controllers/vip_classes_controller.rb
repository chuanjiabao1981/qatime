class VipClassesController < ApplicationController
  layout  "vip"

  def show
    @questions = Question.includes(:learning_plan).by_vip_class(params[:id]).order("created_at desc").paginate(page: params[:page],:per_page => 10)
    #@questions = Question.by_vip_class(params[:id]).order("created_at desc").paginate(page: params[:page],:per_page => 10)
    #@questions = Question.includes(learning_plan: :teachers).by_vip_class(params[:id]).order("created_at desc").paginate(page: params[:page],:per_page => 10)


  end

  private
  def current_resource
    @vip_class = VipClass.find(params[:id])
  end
end
