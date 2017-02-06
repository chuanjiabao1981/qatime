class Workstation::WorkstationsController < Workstation::BaseController
  before_action :set_city

  def customized_courses
    @customized_courses = @workstation.customized_courses.order(:created_at).paginate(page: params[:page])
  end

  def schools
    @schools = @city.schools.order(:created_at).paginate(page: params[:page])
  end

  def teachers
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page])
  end

  def students
    @students = Student.all.order(:created_at).paginate(page: params[:page])
  end

  # 销售
  def sellers
    @sellers = @workstation.sellers.order(id: :desc).paginate(page: params[:page])
  end

  # 客服
  def waiters
    @waiters = @workstation.waiters.order(id: :desc).paginate(page: params[:page])
  end

  def action_records
    @action_records = @workstation.action_records.order(id: :desc).paginate(page: params[:page])
  end

  private

  def set_workstation
    @workstation ||= Workstation.find(params[:id])
  end

  def set_city
    @city = @workstation.city
  end

  def current_resource
    set_workstation
  end
end
