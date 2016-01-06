require_dependency "teaching_program/application_controller"

module TeachingProgram
  class SyllabusesController < ApplicationController
    belongs to :author, class_name: 'Teacher'
   
  end
end
