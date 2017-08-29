require_dependency "resource/application_controller"

module Resource
  class FilesController < ApplicationController
    respond_to :json, :js

    def create
      attach = Attach.create(file_params)
      file = attach.resource_type.create(
          name: file_params[:file].original_filename,
          user: current_user,
          attach: attach,
          ext_name: attach.ext_name,
          file_size: attach.file_size
      )
      respond_with file, location: file_url(file)
    end

    def create_quotes
      binding.pry
    end

    private

    def file_params
      params.require(:file).permit(:file)
    end
  end
end
