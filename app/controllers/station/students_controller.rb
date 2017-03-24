class Station::StudentsController < Station::BaseController

  def index
    @query = Student.by_city(@workstation.try(:city_id)).ransack(params[:q])
    @students = @query.result.order(:created_at).paginate(page: params[:page])
  end

end