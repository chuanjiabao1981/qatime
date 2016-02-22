module CourseLibrary
  module CoursePublicationService
    class Update
      def initialize(course_publication,params)
        @course_publication = course_publication
        @params             = params
      end

      def call
        old_homework_ids    = @course_publication.homework_ids
        new_homework_ids    = @params[:homework_ids]
        new_homework_ids.delete("")

        @params.delete(:homework_ids)

        #需要删除的homework是
        need_delete_homework_ids = old_homework_ids-new_homework_ids
        #需要删除homework publication
        homework_publications = @course_publication.homework_publications.where(homework_id: need_delete_homework_ids)

        homework_publications.each do |homework_publication|
          homework_publication.destroy
        end

        # 需要增加homework是
        need_add_homework_ids   = new_homework_ids - old_homework_ids


        need_add_homework_ids.each do |homework_id|
          @course_publication.homework_publications.create(homework_id: homework_id)
        end


        @course_publication.update_attributes(@params)

        #如果有删除作业的这里要refresh下
        @course_publication.reload
        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(@course_publication).call
        CustomizedTutorialService::CourseLibrary::SyncWithTemplate.new(@course_publication.customized_tutorial).call

        true
      end
    end
  end
end