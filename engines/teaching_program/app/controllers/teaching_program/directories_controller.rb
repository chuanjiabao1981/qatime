require_dependency "teaching_program/application_controller"

module TeachingProgram
  class DirectoriesController < ApplicationController
    belongs to :parent, class_name: 'TeachingProgram::Directory'
    belongs to :syllabus, class_name: 'TeachingProgram::Directory'
    has_many   :courses   
  end
end
