class CoversController < ApplicationController
  respond_to :json,:js
  def create
    @cover = Cover.new(params[:cover].permit!)
    @cover.save
    respond_with @cover
  end
  def update
    @cover = Cover.find(params[:id])
    @cover.update_attributes(params[:cover].permit!)
    respond_with @cover
  end
end
