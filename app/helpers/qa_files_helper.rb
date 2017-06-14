module QaFilesHelper
  def change_params_for_qa_files(params)
    if params["qa_files_attributes"].present?
      qa_files_attributes = params["qa_files_attributes"]
      author_id = current_user.id

      qa_files_attributes.each do |_index, upload_info|
        next unless upload_info["name"].present?
        upload_info["author_id"] = author_id
        original_filename = upload_info["name"].original_filename
        content_type = upload_info["name"].content_type
        upload_info["original_filename"] = original_filename
        upload_info["qa_file_type"] = content_type
      end
    end
    params
  end
end
