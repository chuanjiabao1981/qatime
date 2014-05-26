class Students::CoursesController < ApplicationController
  def purchase
    begin
      current_user.purchase_course(params[:id])
    rescue => err
      err_message = err.to_s
    end
    respond_to do |format|
      format.json {
        if err_message
          render json:{error: err_message}
        else
          render json:{success: :ok}
        end
      }
    end
  end
end
