class SoftwaresController < ApplicationController
  skip_filter :authorize, only: [:download]

  def download
    @software = Software.find(params[:id])
    redirect_to @software.cdn_url
  end
end
