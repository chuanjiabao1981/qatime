require_dependency "live_studio/student/base_controller"

module LiveStudio
  class Student::CoursesController < Student::BaseController
    def index
      @tickets = @student.live_studio_tickets.visiable.includes(course: :teacher)
      if filter_patams[:cate]
        # 根据分类过滤辅导班
        # cate: today今日上课辅导班, taste: 试听辅导班
        @tickets = LiveService::CourseDirector.courses_for_filter(@student, filter_patams[:cate])
      elsif filter_patams[:status]
        # 根据状态过滤辅导班
        # TODO 字符串转换成数据库整形数值
        status = LiveStudio::Course.statuses[filter_patams[:status]]
        @tickets = @tickets.joins(:course).where(live_studio_courses: { status: status })
      end
      @tickets = @tickets.paginate(page: params[:page])
      render layout: 'student_home_new'
    end

    def show
      @course = Course.find(params[:id])
      @ticket = @student.live_studio_tickets.visiable.find_by(course_id: params[:id])
      @lessons = @course.lessons.order(:id).paginate(page: params[:page])
      @play_records = PlayRecord.where(user_id: @student.id, lesson_id: @lessons.map(&:id))
      @play_hash = @play_records.inject({}){ |hash, v| hash[v.lesson_id] = v.id; hash }
      render layout: 'student_home_new'
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
