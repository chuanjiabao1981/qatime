require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::VideoCoursesController < Station::ApplicationController
    before_action :find_course, only: [:send_qr_code]

    before_action :set_video_course_and_check, only: [:edit, :update, :publish]

    def index
      @query = LiveStudio::VideoCourse.published.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def my_publish
      @query = @workstation.live_studio_video_courses.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def my_sells
      @query = LiveStudio::VideoCourse.published.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    # 发送二维码
    def send_qr_code
      code = @workstation.coupon.try(:code)
      return render text: I18n.t('view.live_studio/courses.no_coupon_code') if code.blank?

      qr_code_url = @video_course.generate_qrcode_by_coupon(code)
      image = URI(qr_code_url).read
      send_data image, type: "#{image.content_type};charset=utf-8;header=present", filename: "#{@video_course.name.to_s}.png", disposition: 'attachment'
    end

    # 工作站视频课管理
    def list
      @video_courses = @workstation.live_studio_video_courses.includes(:teacher).where(cate_params)
      @query = @video_courses.ransack(ransack_params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def edit
    end

    def update
      @video_course.context = 'complete'
      if @video_course.update(video_course_params)
        @video_course.complete! if @video_course.confirmed?
        notice = I18n.t('live_studio.notices.video_course.updated')
        if params[:publish].present?
          @video_course.publish!
          notice = I18n.t('live_studio.notices.video_course.published')
        end
        redirect_to live_studio.list_station_workstation_video_courses_path(@workstation, cate: 'has_created'), notice: notice
      else
        render :edit
      end
    end

    def publish
      @video_course.publish! if @video_course.completed?
      redirect_to live_studio.list_station_workstation_video_courses_path(@workstation, cate: 'has_created'), notice: I18n.t('live_studio.notices.video_course.published')
    end

    private

    def find_course
      @video_course = LiveStudio::VideoCourse.find(params[:id])
    end

    def ransack_params
      @ransack_params ||= params.permit(q: [:grade_eq, :subject_eq])
      @ransack_params[:q] ||= {}
      @ransack_params
    end

    def set_video_course_and_check
      @video_course = @workstation.live_studio_video_courses.find(params[:id])
      redirect_to live_studio.list_station_workstation_video_courses_path(@workstation), notice: '视频课状态不正确.' unless %w(confirmed completed).include?(@video_course.status)
    end

    def cate_params
      statuses = %w(confirmed)
      statuses = %w(completed published) if params[:cate] == 'has_created'
      { status: LiveStudio::VideoCourse.statuses.values_at(*statuses) }
    end

    def video_course_params
      params.require(:video_course).permit(:name, :grade, :description, :objective, :suit_crowd, :sell_type, :price, :teacher_percentage,
                                           video_lessons_attributes: [:id, :tastable])
    end
  end
end
