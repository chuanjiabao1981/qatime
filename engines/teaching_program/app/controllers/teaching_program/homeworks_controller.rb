require_dependency "teaching_program/application_controller"

module TeachingProgram
  class HomeworksController < ApplicationController
    belongs to :course
    has many :solutions
  end
end
