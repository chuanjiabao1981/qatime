require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::CoursesController < Teacher::BaseController

    before_action :set_course, only: [:show, :edit, :update, :destroy, :channel, :close]

    def index
      @courses = courses_chain
      if filter_patams[:cate] && filter_patams[:cate] == 'today'
        # 根据分类过滤辅导班
        # cate: today今日上课辅导班
        @courses = courses_chain.includes(:lessons).where(live_studio_lessons: { class_date: Date.today })
      elsif filter_patams[:status]
        # 根据状态过滤辅导班
        # TODO 字符串转换成数据库整形数值
        status = LiveStudio::Course.statuses[filter_patams[:status]]
        @courses = @courses.where(status: status)
      end
      @courses = @courses.paginate(page: params[:page])
    end

    def show
      @lessons = @course.lessons.order("id").paginate(page: params[:page])
    end

    def edit
    end

    # PATCH/PUT /teachers/:teacher_id/courses/:id
    def update
      if @course.update(teacher_course_params)
        redirect_to teacher_course_path(@teacher, @course), notice: i18n_notice('updated', @course)
      else
        render :edit
      end
    end

    def channel
      @course.channels.destroy_all
      @course.init_channel
      @channel = @course.channels.last
    end

    def close
      @course.completed! if @course.ready_for_close?
      redirect_to teacher_course_path(@teacher, @course), notice: i18n_notice('closed', @course)
    end

    private

    def courses_chain
      @teacher.live_studio_courses
    end

    def set_course
      @course = courses_chain.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through for update.
    def teacher_course_params
      params.require(:course).permit(:name, :description,:publicize)
    end

    def filter_patams
      # status参数和cate参数保留一个
      # 使用分类查询不能使用状态查询
      @filter_patams = params.slice(:cate, :status)
      @filter_patams.delete(:status) if @filter_patams[:cate]
      @filter_patams
    end
  end
end
