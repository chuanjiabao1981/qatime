class QaFilesController < ApplicationController
  respond_to :html, :json,:js
  def index
    @qa_files = QaFile.where(:author_id => current_user.id).order(:created_at => "DESC").paginate(page: params[:page],:per_page => 10)
  end

  def create
  end

  def new
    Rails.logger.info "qafile_new"
    @qa_file = QaFile.new
  end
end