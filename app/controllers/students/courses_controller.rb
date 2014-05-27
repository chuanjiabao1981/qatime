class Students::CoursesController < ApplicationController
  def purchase
    begin
      current_user.purchase_course(params[:id])
    rescue => err
      @err_message = err.to_s
    end
    respond_to do |format|
      format.js {}
    end
  end
end
