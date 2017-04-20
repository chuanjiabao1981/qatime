require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    layout 'student_home_new'

    def index
      @courses = LiveService::StudentLiveDirector.new(@student).courses(params)
      @courses = @courses.includes(:lessons).paginate(page: params[:page])
    end

    def show
      @course = Course.find(params[:id])
      @ticket = @student.live_studio_tickets.by_product(@course).try(:first)
      @lessons = @course.lessons.order(:id).paginate(page: params[:page])
      @play_records = PlayRecord.where(user_id: @student.id, lesson_id: @lessons.map(&:id))
      @play_hash = @play_records.inject({}){ |hash, v| hash[v.lesson_id] = v.id; hash }
    end

    private

    def filter_patams
      # status参数和cate参数保留一个
      # 使用分类查询不能使用状态查询
      @filter_patams = params.slice(:cate, :status)
      @filter_patams.delete(:status) if @filter_patams[:cate]
      @filter_patams
    end
  end
end
