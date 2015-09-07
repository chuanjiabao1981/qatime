class Homework < ActiveRecord::Base


  include QaToken
  include ContentValidate


  belongs_to      :customized_course
  belongs_to      :teacher
  has_many        :topics ,as: :topicable,:dependent => :destroy
  has_many        :qa_files, as: :qa_fileable, :dependent => :destroy
  accepts_nested_attributes_for :qa_files, allow_destroy: true

end
