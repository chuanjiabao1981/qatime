class SoftwaresController < ApplicationController
  def download
    @software = Software.find(params[:id])
    redirect_to @software.cdn_url
  end
end
