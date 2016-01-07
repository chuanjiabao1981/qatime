require_dependency "teaching_program/application_controller"

module TeachingProgram
  class HomeworksController < ApplicationController
    belongs to :course
    has many :solutions
    has many :qa_files, as: :qa_fileable
    has many :picture, as: :imageable 
  end
end
