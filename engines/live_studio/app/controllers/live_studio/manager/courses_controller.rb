require_dependency "live_studio/manager/base_controller"

module LiveStudio
  class Manager::CoursesController < Manager::BaseController
    before_action :set_course, only: [:show, :edit, :update, :destroy]

    # GET /manager/courses
    def index
      @courses = @manager.live_studio_courses.paginate(page: params[:page])
    end

    # GET /manager/courses/1
    def show
      @lessons = @course.lessons.order("id").paginate(page: params[:page])
    end

    # GET /manager/courses/new
    def new
      @course = Course.new
      @workstations = workstations
    end

    # GET /manager/courses/1/edit
    def edit
    end

    # POST /manager/courses
    def create
      @course = @manager.live_studio_courses.new(course_params)
      if @course.save
        LiveService::ChatAccountFromUser.new(@course.teacher).instance_account
        redirect_to manager_course_path(@current_user, @course), notice: i18n_notice('created', @course)
      else
        @workstations = workstations
        render :new
      end
    end

    # PATCH/PUT /manager/courses/1
    def update
      if @course.update(course_params)
        redirect_to manager_course_path(@manager, @course), notice: i18n_notice('updated', @course)
      else
        render :edit
      end
    end

    # DELETE /manager/courses/1
    def destroy
      @course.destroy
      redirect_to manager_courses_url, notice: i18n_notice('destroyed', @course)
    end

    private

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:name, :teacher_id, :description, :workstation_id, :price)
    end

    # Only allow a trusted parameter "white list" through for update.
    def manager_course_params
      params.require(:course).permit(:name, :teacher_id, :description, :workstation_id, :price)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(
          :name, :teacher_id, :description, :workstation_id, :price, :teacher_percentage,
          :preset_lesson_count, :subject, :grade
      )
    end

    def workstations
      @manager.workstations.select(:id, :name).map {|w| [w.name, w.id] }
    end

  end
end
