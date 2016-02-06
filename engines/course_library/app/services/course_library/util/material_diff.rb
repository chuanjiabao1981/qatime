module CourseLibrary
  module Util
    class MaterialDiff
      def initialize(template,other)
        @template = template
        @other    = other
      end
      def call
        diff = []
        return diff if @template.nil? and @other.nil?
        if @template.nil?
          diff << "template is nil"
          return diff
        end
        if @other.nil?
          diff << "other is nil"
          return diff
        end

        if @other.respond_to?(:template_video) and @template.respond_to?(:video)
          if @other.template_video  != @template.video
            diff << "video"
          end
        end

        if @other.respond_to?(:template_picture_ids) and @template.respond_to?(:picture_ids)
          if not same_array?(@other.template_picture_ids,@template.picture_ids)
            diff << "pictures"
          end
        end

        if @other.respond_to?(:template_file_ids) and @template.respond_to?(:qa_file_ids)
          if not same_array?(@other.template_file_ids,@template.qa_file_ids)
            diff << "files"
          end
        end
      end

      private
      def same_array?(a,b)
        a = a || []
        b = b || []
        a.uniq.sort  == b.uniq.sort
      end
    end
  end
end