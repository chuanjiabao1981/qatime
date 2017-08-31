require_dependency "resource/application_controller"

module Resource
  class Teacher::FilesController < Teacher::BaseController
    before_action :find_file, only: [:destroy]

    def index
      @files = @teacher.files
      @files = @files.where(type: file_type(params[:cate])) if params[:cate].present?
      @files = @files.order(created_at: :desc).paginate(page: params[:page])
    end

    def destroy
      quote = Quote.find_by(quoter: @teacher, file_id: @file.id)
      quote.destroy
      redirect_to teacher_files_path(@teacher, cate: params[:cate])
    end

    private

    def file_type(cate)
      "Resource::#{cate.camelize}File"
    end

    def find_file
      @file = Resource::File.find(params[:id])
    end
  end
end
