module CourseLibrary
  module CoursePublicationService
    class Update
      def initialize(course_publication,params)
        @course_publication = course_publication
        @params             = params
      end

      def call
        @old_homework_ids           = @course_publication.homework_ids
        @new_homework_ids           = @params[:homework_ids].nil? ? [] : @params[:homework_ids]
        @new_homework_ids           = @new_homework_ids.map {|x| x.to_i}
        @need_delete_homework_ids   = []
        @new_homework_ids.delete("")


        #需要删除的homework是

        @need_delete_homework_ids   = @old_homework_ids - @new_homework_ids
        @need_add_homework_ids      = @new_homework_ids - @old_homework_ids


        service_respond = _un_publish_valid?(@course_publication)
        if not service_respond.success?
          return service_respond
        end

        @params.delete(:homework_ids)

        #需要删除（撤销）homework publication
        homework_publications = @course_publication.homework_publications.where(homework_id: @need_delete_homework_ids)

        homework_publications.each do |homework_publication|
          homework_publication.destroy
        end

        #需要撤销lecture
        if @params[:publish_lecture_switch] == "0" || @params[:publish_lecture_switch] == false
          if @course_publication.customized_tutorial
            @course_publication.customized_tutorial.destroy_lecture
          end
        end


        #发布新的作业
        @need_add_homework_ids.each do |homework_id|
          @course_publication.homework_publications.create(homework_id: homework_id)
        end

        #如果有删除作业的这里要refresh下
        @course_publication.reload


        @course_publication.update_attributes(@params)

        #可能有lecture或者作业要发布
        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(@course_publication).call

        return ServiceRespond.new
      end

      private
      def _un_publish_valid?(course_publication)
        @need_delete_homework_ids.each do |homework_id|
          if not CourseLibrary::HomeworkPublicationService::CanUnPublish.new(course_publication,homework_id).call
            homework = Homework.find(homework_id)
            return ServiceRespond.new.add_error("#{homework.title} 已经计费无法撤销")
          end
        end


        if @params[:publish_lecture_switch] == "0" || @params[:publish_lecture_switch] == false
          #如果要撤销 判断下是否可以撤销
          if not CourseLibrary::CoursePublicationService::CanLectureUnPublish.new(course_publication).call
            return ServiceRespond.new.add_error("课件已经计费无法撤销")
          end
        end

        return ServiceRespond.new

      end
    end
  end
end