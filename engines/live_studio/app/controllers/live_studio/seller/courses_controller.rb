module LiveStudio
  class Seller::CoursesController < Seller::BaseController
    before_action :set_course, only: [:show, :edit, :update, :destroy, :publish]

    # GET /manager/courses
    def index
      @courses = @seller.live_studio_courses.paginate(page: params[:page])
    end

    # GET /manager/courses/1
    def show
      @lessons = @course.lessons.order(:id).paginate(page: params[:page])
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
      @course = @current_user.live_studio_courses.new(course_params.merge(author: current_user))

      if @course.save
        redirect_to seller_course_path(@seller, @course), notice: i18n_notice('created', @course)
      else
        @workstations = workstations
        render :new
      end
    end

    # 开始招生
    def publish
      if @course.init?
        @course.publish!
        LiveService::CourseDirector.new(@course).instance_for_course
      end
    end

    # PATCH/PUT /manager/courses/1
    def update
      if @course.update(course_params)
        redirect_to seller_course_path(@seller, @course), notice: i18n_notice('updated', @course)
      else
        render :edit
      end
    end

    # DELETE /manager/courses/1
    def destroy
      @course.destroy
      redirect_to seller_courses_url, notice: i18n_notice('destroyed', @course)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.require(:course).permit(:name, :teacher_id, :description, :workstation_id, :price, :teacher_percentage)
    end

    def workstations
      [[current_user.workstation.name, current_user.workstation_id]]
    end

  end
end
