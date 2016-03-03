module CourseLibrary
  module CoursePublicationService
    class Create
      def initialize(course,course_publication_form)
        @course                      = course
        @course_publication_form     = course_publication_form
      end

      def call
        #到这里的course_publication都是validate过的所以不需要验证什么

        #找到或者创建course_publication
        course_publications = _find_or_build_course_publication(@course,@course_publication_form)
        #找到或者创建homework_publication
        _find_or_build_homework_publication(course_publications,@course_publication_form.homework_ids)

        course_publications.each do |course_publication|
          course_publication.save #TODO:: 测试homework publication增加
          CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(course_publication).call
        end

      end

      private
      def _find_or_build_course_publication(course,course_publication_form)
        course_publication_form.customized_course_ids.map do |i|
          course.course_publications.find_or_create_by(customized_course_id: i) do |course_publication|
            #因为是用于发布不是更新所以即便form不选择也不能同步到原有的publish上
            if course_publication_form.publish_lecture_switch
              course_publication.publish_lecture_switch = course_publication_form.publish_lecture_switch
            end
          end
        end
      end

      def _find_or_build_homework_publication(course_publications,homework_ids)
        course_publications.each do |cp|
          homework_ids.each do |h|
            cp.homework_publications.find_or_create_by(homework_id: h)
          end
        end
      end
    end
  end
end