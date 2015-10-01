class Homework < ActiveRecord::Base


  include QaToken
  include ContentValidate
  include QaSolution
  include QaCommon

  belongs_to      :customized_course,counter_cache: true
  belongs_to      :teacher
  belongs_to      :student
  # has_many        :topics ,as: :topicable,:dependent => :destroy
  has_many        :qa_files, as: :qa_fileable, :dependent => :destroy
  has_many        :pictures,as: :imageable,:dependent => :destroy

  accepts_nested_attributes_for :qa_files, allow_destroy: true

  has_many        :solutions,as: :solutionable,:dependent =>  :destroy  do
    def build(attributes={})
      attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      super attributes
    end
  end

  self.per_page = 10
  def author
    self.teacher
  end
  def name
    self.title
  end


end
