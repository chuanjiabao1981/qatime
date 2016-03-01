module CourseLibrary

  class PublishContentNotNull < ActiveModel::Validator
    def validate(record)
      if record.publish_lecture_switch == false and record.homework_ids.length == 0
        record.errors[:base] << "发布的内容不可为空"
      end
    end
  end

  class CoursePublicationForm
    include Virtus.model
    include ActiveModel::Model

    attribute :customized_course_ids,Array[Integer]

    attribute :publish_lecture_switch,Axiom::Types::Boolean,default: false

    attribute :homework_ids,Array[Integer]

    validates :customized_course_ids, :length => {:minimum => 1,:message => "至少选择一个学生"}

    validates_with CourseLibrary::PublishContentNotNull
  end


end