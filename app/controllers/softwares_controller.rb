class SoftwaresController < ApplicationController
  layout 'v1/application'

  skip_filter :authorize, only: [:index, :download, :latest]

  def index
    @categories = SoftwareCategory.available.includes(:softwares)
  end

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

  def app
    @android_app, @ios_app =
      if params[:role] == 'teacher'
        load_teacher_app
      else
        load_student_app
      end
    render layout: 'wap'
  end

  private

  def load_teacher_app
    @teacher_android_app, @teacher_ios_app = Software.teacher_apps
  end

  def load_student_app
    @student_android_app, @student_ios_app = Software.student_apps
  end
end
