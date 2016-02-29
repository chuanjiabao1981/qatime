module CourseLibrary
  class CoursePublicationForm
    include Virtus.model
    include ActiveModel::Model

    attribute :customized_course_ids,Array[Integer]

    attribute :publish_lecture_switch,Axiom::Types::Boolean,default: false

    attribute :homework_ids,Array[Integer]

    validates :customized_course_ids, :length => {:minimum => 1,:message => "至少选择一个学生"}

    
  end
end