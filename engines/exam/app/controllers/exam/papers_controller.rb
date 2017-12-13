require_dependency "exam/application_controller"

module Exam
  class PapersController < ApplicationController
    def index
      @q = Exam::Paper.for_sell.ransack(search_params[:q])
      @papers = @q.result.paginate(page: params[:page], per_page: 12)
    end

    def show
      @paper = Exam::Paper.find(params[:id])
    end

    private

    def search_params
      params[:q] ||= {}
      params[:q][:s] ||= "users_count desc"
      params.permit(q: [:s])
    end
  end
end
