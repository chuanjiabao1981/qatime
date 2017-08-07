class Wap::LiveStudio::CustomizedGroupsController < Wap::ApplicationController
  before_action :set_customized_group, only: [:show]

  def show
  end

  private

  def set_customized_group
    @customized_group = LiveStudio::CustomizedGroup.find(params[:id])
  end
end
