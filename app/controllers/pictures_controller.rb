class PicturesController < ApplicationController
  respond_to :html,:json
  def index
    @pictures = Picture.all
  end
  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new(params[:picture].permit!)
    @picture.save
    respond_with @picture
  end
end
