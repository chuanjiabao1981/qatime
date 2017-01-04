class SellersController < ApplicationController

  layout 'seller_home'
  def customized_courses
    @customized_courses = @seller.customized_courses.order(:created_at => :asc).paginate(page: params[:page],:per_page => 10)
  end

  private
  def current_resource
    @seller = Seller.find(params[:id]) if params[:id]
  end

end
