require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::VideoCoursesController < Station::ApplicationController
    before_action :find_course, only: [:send_qr_code, :audit]

    def index
      @query = LiveStudio::VideoCourse.published.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def my_publish
      @query = @workstation.live_studio_video_courses.published.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def my_sells
      @query = LiveStudio::VideoCourse.published.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    def audits
      params[:cate] ||= 'no_audit'
      case params[:cate]
        when 'audited'
          video_courses = LiveStudio::VideoCourse.audited
        else
          video_courses = LiveStudio::VideoCourse.no_audit
      end

      @query = video_courses.ransack(params[:q])
      @video_courses = @query.result.order(id: :desc).paginate(page: params[:page])
    end

    # 通过/驳回
    def audit
      @video_course.confirm! if params[:audit] == 'pass' && @video_course.may_confirm?
      @video_course.reject! if params[:audit] == 'reject' && @video_course.may_reject?
      redirect_to :back
    end

    # 发送二维码
    def send_qr_code
      code = @workstation.coupon.try(:code)
      return render text: I18n.t('view.live_studio/courses.no_coupon_code') if code.blank?

      qr_code_url = @video_course.generate_qrcode_by_coupon(code)
      image = URI(qr_code_url).read
      send_data image, type: "#{image.content_type};charset=utf-8;header=present", filename: "#{@video_course.name.to_s}.png", disposition: 'attachment'
    end

    private

    def find_course
      @video_course = LiveStudio::VideoCourse.find(params[:id])
    end

  end
end
