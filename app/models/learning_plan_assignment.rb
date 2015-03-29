class LearningPlanAssignment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :learning_plan
end
