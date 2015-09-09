module QaFilesHelper
  def change_params_for_qa_files(params)
    
    if params["qa_files_attributes"].present?
      qa_files_attributes = params["qa_files_attributes"]
      author_id = current_user.id

      qa_files_attributes.each{|qa_files_attribute|
        upload_info = qa_files_attribute.at(1)
        if not upload_info["name"].nil?
          upload_info = qa_files_attribute.at(1)
          upload_info["author_id"] = author_id
          original_filename = upload_info["name"].original_filename
          content_type = upload_info["name"].content_type
          upload_info["original_filename"] = original_filename
          upload_info["qa_file_type"] = content_type
        end
      }
    end

    params
  end
end