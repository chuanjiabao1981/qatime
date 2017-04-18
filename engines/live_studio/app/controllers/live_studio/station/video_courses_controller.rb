require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::VideoCoursesController < Station::ApplicationController
    before_action :find_course, only: [:send_qr_code]

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
      @video_courses = @workstation.live_studio_video_courses.where(status: LiveStudio::VideoCourse.statuses[params[:status] || 'confirmed'])
      @video_courses = @video_courses.ransack(ransack_params)
      @video_courses = @video_courses.result.order(id: :desc).paginate(page: params[:page])
    end

    private

    def find_course
      @video_course = LiveStudio::VideoCourse.find(params[:id])
    end

    def ransack_params
      params.permit(q: [:grade, :subject, :status])
    end

  end
end
