module LiveStudio
  class Waiter::CoursesController < Waiter::BaseController
    before_action :set_course, only: [:show, :edit, :update, :destroy, :publish]

    # GET /manager/courses
    def index
      @courses = @current_resource.live_studio_courses.paginate(page: params[:page])
    end

    # GET /manager/courses/1
    def show
      @lessons = @course.lessons
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
      @course = @current_user.live_studio_courses.new(course_params)

      if @course.save
        redirect_to waiter_course_path(@current_resource, @course), notice: i18n_notice('created', @course)
      else
        @workstations = workstations
        render :new
      end
    end

    # 开始招生
    def publish
      @course.preview! if @course.init?
    end

    # PATCH/PUT /manager/courses/1
    def update
      if @course.update(course_params)
        redirect_to waiter_course_path(@current_resource, @course), notice: i18n_notice('updated', @course)
      else
        render :edit
      end
    end

    # DELETE /manager/courses/1
    def destroy
      @course.destroy
      redirect_to waiter_courses_url, notice: i18n_notice('destroyed', @course)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:name, :teacher_id, :description, :workstation_id, :price, :teacher_percentage, :preset_lesson_count)
    end

    def workstations
      [[current_user.workstation.name, current_user.workstation_id]]
    end

  end
end
