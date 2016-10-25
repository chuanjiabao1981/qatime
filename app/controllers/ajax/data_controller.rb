class Ajax::DataController < ApplicationController
  before_action :set_variable

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
