require_dependency "teaching_program/application_controller"

module TeachingProgram
  class SolutionsController < ApplicationController
    belongs to :homework
    has one :video, as: :videoable 
  end
end
