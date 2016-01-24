module QaTemplate
  module Material
    extend ActiveSupport::Concern
    included do
      has_many        :qa_file_quoters,as: :file_quoter,:dependent => :destroy
      has_many        :template_files,through: :qa_file_quoters,source: :qa_file
      has_many        :picture_quoters,as: :file_quoter,:dependent => :destroy
      has_many        :template_pictures,through: :picture_quoters,source: :picture
    end
  end
end