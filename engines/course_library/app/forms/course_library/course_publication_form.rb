module CourseLibrary

  class PublishContentNotNull < ActiveModel::Validator
    def validate(record)
      if record.publish_lecture_switch == false and record.homework_ids.length == 0
        record.errors.add(:publish_lecture_switch,"选择发布课件")
        record.errors.add(:homework_ids, "请选择发布的作业")
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


    def homework_ids=(h)
      h.delete("")
      super(h)
    end

    def customized_course_ids=(c)
      c.delete("")
      super(c)
    end

    def persisted?
      false
    end

    def submit(course)
      if valid?
        ActiveRecord::Base.transaction do
          persist(course)
        end

        true
      else
        false
      end
    end

    private
    def persist(course)
      CourseLibrary::CoursePublicationService::Create.new(course,self).call
    end
  end


end