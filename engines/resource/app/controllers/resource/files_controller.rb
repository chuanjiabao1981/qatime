require_dependency "resource/application_controller"

module Resource
  class FilesController < ApplicationController
    respond_to :json, :js
    before_action :load_quoter_files, only: [:create_quotes]
    before_action :find_file, only: [:delete_quote]

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
      @files.each do |file|
        quote = Quote.find_or_initialize_by(quoter: @quoter, file_id: file.id)
        quote.name = quote_params[:name]
        quote.save if quote.changed?

        teacher_quote = Quote.find_or_initialize_by(quoter: current_user, file_id: file.id)
        teacher_quote.name = quote_params[:name]
        teacher_quote.save if teacher_quote.changed?
      end

      respond_to do |f|
        f.html { redirect_to params[:back_url].presence || main_app.root_url }
      end
    end

    def delete_quote
      @quoter = params[:quoter_type].constantize.find(params[:quoter_id])
      @quote = Resource::Quote.find_by(quoter: @quoter, file_id: @file.id)
      if @quote.destroy
        render json: {success: true}
      else
        render json: {success: false}
      end
    end

    private

    def load_quoter_files
      @files = Resource::File.where(id: params[:file_ids])
      @quoter = quote_params[:quoter_type].constantize.find(quote_params[:quoter_id])
    end

    def find_file
      @file = Resource::File.find(params[:id])
    end

    def file_params
      params.require(:file).permit(:file)
    end

    def quote_params
      params.require(:quote).permit(:name, :quoter_type, :quoter_id)
    end
  end
end
