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

        if not new_homework_ids.nil?
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
        end

        #如果有删除作业的这里要refresh下
        @course_publication.reload

        #如果要撤销lecture的发布，
        if not @params[:publish_lecture_switch]
          if @course_publication.publish_lecture_switch
            # 判断是否计费
            # 如果已经计费则不能修改此值
            @course_publication.customized_tutorial.is_charged?
            if @course_publication.customized_tutorial.is_charged?

              @params[:publish_lecture_switch] = @course_publication.publish_lecture_switch
            end
          end
        end

        @course_publication.update_attributes(@params)

        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(@course_publication).call
        CustomizedTutorialService::CourseLibrary::SyncWithTemplate.new(@course_publication.customized_tutorial).call

        true
      end

      private
      def _update_validate(course_publication,need_delete_homework_ids)
        need_delete_homework_ids.each do |homework_id|
          if not CourseLibrary::HomeworkPublicationService::CanUnPublish.new(course_publication,homework_id).call
            return false
          end
        end
        
      end
    end
  end
end