class VipClassesController < ApplicationController
  layout  "vip"

  def show
    @questions = Question.by_vip_class(params[:id])
  end

  private
  def current_resource
    @vip_class = VipClass.find(params[:id])
  end
end
