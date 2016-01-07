require_dependency "teaching_program/application_controller"

module TeachingProgram
  class CoursesController < ApplicationController
    belongs to :directory
    has one :video, as: :videoable 
    has many :homeworks 
     
  end
end
