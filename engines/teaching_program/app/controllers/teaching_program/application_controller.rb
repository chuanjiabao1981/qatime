module TeachingProgram
  class ApplicationController < ::ApplicationController
    def unauthorized
      redirect_to main_app.root_path
    end
  end
end
