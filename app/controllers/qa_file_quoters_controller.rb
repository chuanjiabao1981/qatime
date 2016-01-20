class QaFileQuotersController < ApplicationController
  def create
    @qa_file_quoter = QaFileQuoter.new(params[:qa_file_quoter].permit!)
    @qa_file_quoter.save
    respond_with @qa_file_quoter
  end

  def destroy
    @qa_file_quoter.destory
    respond_with @qa_file_quoter
  end
  private
  def current_resource
    if params[:id]
      @qa_file_quoter = QaFileQuoter.find(params[:id])
    end
  end
end
