class SoftwaresController < ApplicationController
  skip_filter :authorize, only: [:download, :latest]

  def download
    @software = Software.find(params[:id])
    redirect_to @software.cdn_url
  end

  def latest
    @software = Software.published.where(category: Software.categories[params[:cate]],
                                         platform: SoftwareCategory.platforms[params[:platform]]).order(published_at: :desc).try(:first)

    respond_to do |format|
      format.json {
        render json: {url: @software.try(:cdn_url) }
      }
      format.html {}
    end

  end
end
