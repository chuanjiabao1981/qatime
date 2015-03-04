class Curriculum < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :teaching_program
end
