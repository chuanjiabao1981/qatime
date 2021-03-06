module QaTemplate
  module Material
    extend ActiveSupport::Concern
    included do
      has_many        :qa_file_quoters,as: :file_quoter,:dependent => :destroy
      has_many        :template_files,through: :qa_file_quoters,source: :qa_file
      has_many        :picture_quoters,as: :file_quoter,:dependent => :destroy
      has_many        :template_pictures,through: :picture_quoters,source: :picture
    end
    def qa_files
      #如果是模板
      if template and not template.nil?
        return template_files
      else
        if defined?(super)
          super
        else
          nil
        end
      end
    end

    def template
      if respond_to?(:course_publication) and not course_publication.nil?
        return course_publication.course
      end
      if respond_to?(:homework_publication) and not homework_publication.nil?
        return homework_publication.homework
      end
      if defined?(super)
        return super
      end
      nil
    end
  end

end