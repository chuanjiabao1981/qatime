class Station::SchoolsController < Station::BaseController
  layout 'v1/manager_home'

  before_action :find_school, only: [:edit, :update]

  def index
    @query = School.where(city_id: @workstation.try(:city_id)).ransack(params[:q])
    @schools = @query.result.order(:created_at).paginate(page: params[:page])
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    @school.city_id = @workstation.city_id
    if @school.save
      redirect_to station_workstation_schools_path(@workstation)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @school.update(school_params)
      redirect_to station_workstation_schools_path(@workstation)
    else
      render :edit
    end
  end

  private
  def find_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name)
  end
end
