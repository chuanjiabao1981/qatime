class Ajax::DataController < ApplicationController
  before_action :set_variable
  skip_before_action :authorize

  def option_cities
    respond_to do |format|
      format.js
    end
  end

  def option_schools
    respond_to do |format|
      format.js
    end
  end

  def home_curriculums
    @curriculums = Curriculum.by_subject(params[:subject]).limit(8)
    respond_to do |format|
      format.html{ render layout: false}
    end
  end

  def home_questions
    @questions = Question.all.includes({learning_plan: :teachers},:vip_class,:student).order("created_at desc").limit(4)
    respond_to do |format|
      format.html{ render layout: false}
    end
  end

  private
  def set_variable
    set_cities if params[:second]
    set_schools if params[:third]
  end

  def set_cities
    @cities = Province.find(params[:teacher][:province_id]).cities
  end

  def set_schools
    @schools = params[:teacher][:city_id].blank? ? @cities.first.schools : City.find(params[:teacher][:city_id]).schools
  end
end
