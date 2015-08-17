class QuestionAssignment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :question
end
