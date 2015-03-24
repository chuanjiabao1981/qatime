class Answer < ActiveRecord::Base
  belongs_to :question ,counter_cache: true
  belongs_to :teacher
  validates :content, length: { minimum: 20 }

end
