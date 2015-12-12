class PicturesController < ApplicationController
  respond_to :html,:json,:js
  def index
    @pictures = Picture.all
  end
  def new
    @picture = Picture.new
  end

  def create
    @picture          = Picture.new(params[:picture].permit!)
    @picture.author   = current_user
    @picture.save
    respond_with @picture
  end

  def destroy
    @picture.destroy
    respond_with @picture
  end

  private
  def current_resource
    if params[:id]
      @picture = Picture.find(params[:id])
    end
  end
end
