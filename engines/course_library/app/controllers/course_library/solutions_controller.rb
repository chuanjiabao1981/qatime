require_dependency "course_library/application_controller"

module CourseLibrary
  class SolutionsController < ApplicationController
    respond_to :json,:js

    def video
      @video = @solution.video
      @video_player_id = rand(10000)

      respond_with @video
    end
    private
    def current_resource
      if params[:id]
        @solution = Solution.find(params[:id])
      end
    end
  end
end
