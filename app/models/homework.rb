class Homework < ActiveRecord::Base


  include QaToken
  include ContentValidate

  belongs_to      :customized_course,counter_cache: true
  belongs_to      :teacher
  has_many        :topics ,as: :topicable,:dependent => :destroy
  has_many        :qa_files, as: :qa_fileable, :dependent => :destroy
  has_many        :pictures,as: :imageable,:dependent => :destroy

  accepts_nested_attributes_for :qa_files, allow_destroy: true

  has_many        :solutions,:dependent =>  :destroy


  def name
    self.title
  end

  def corrections_count
    s = 0
    self.solutions.each do |c|
      s+=c.corrections_count
    end
    s
  end
end
