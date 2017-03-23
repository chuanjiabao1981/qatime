class Station::TeachersController < Station::BaseController

  def index
    @query = Teacher.by_city(@workstation.try(:city_id)).ransack(params[:q])
    @teachers = @query.result.order(:created_at).paginate(page: params[:page])
  end

end
