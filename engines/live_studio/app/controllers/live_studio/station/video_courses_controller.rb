require_dependency "live_studio/application_controller"

module LiveStudio
  class Station::VideoCoursesController < Station::ApplicationController
    before_action :find_course, only: [:send_qr_code, :audit]

    before_action :set_video_course_and_check, only: [:edit, :update, :publish]

    def index
      @query = LiveStudio::VideoCourse.published.sell_and_platform_percentage_greater_than(@workstation.platform_percentage).ransack(params[:q])
      @video_courses = @query.result.includes(:teacher, :workstation, :video_lessons).order(id: :desc).paginate(page: params[:page])
    end

    def my_publish
      @query = @workstation.live_studio_video_courses.published.ransack(params[:q])
      @video_courses = @query.result.includes(:teacher, :workstation, :video_lessons).order(id: :desc).paginate(page: params[:page])
    end

    def my_sells
      @query = @workstation.sell_live_studio_video_courses.includes(:teacher, :workstation).ransack(params[:q])
      @video_courses = @query.result.paginate(page: params[:page])
      @tickets = @workstation.sell_live_studio_tickets.where(product_type: 'LiveStudio::VideoCourse', product_id: @video_courses.map(&:id))
      @tickets_count = @tickets.select('live_studio_tickets.product_id, count(live_studio_tickets.product_id) as ticket_count')
                           .group('live_studio_tickets.product_id').reorder('live_studio_tickets.product_id')
                           .map {|t| [t.product_id, t.ticket_count]}.to_h
    end

    def audits
      params[:cate] ||= 'no_audit'
      case params[:cate]
        when 'audited'
          video_courses = @workstation.live_studio_video_courses.audited
        else
          video_courses = @workstation.live_studio_video_courses.no_audit
      end
      @query = video_courses.ransack(params[:q])
      @video_courses = @query.result.includes(:teacher, :video_lessons).order(id: :desc).paginate(page: params[:page])
      render layout: 'v1/manager_home'
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

    # 工作站视频课管理
    def list
      params[:cate] ||= 'confirmed'
      case params[:cate]
      when 'completed'
        video_courses = @workstation.live_studio_video_courses.completed
      when 'published'
        video_courses = @workstation.live_studio_video_courses.published
      else
        video_courses = @workstation.live_studio_video_courses.confirmed
      end

      @query = video_courses.ransack(params[:q])
      @video_courses = @query.result.includes(:teacher, :video_lessons).order(id: :desc).paginate(page: params[:page])
      render layout: 'v1/manager_home'
    end

    def edit
      render layout: 'v1/manager_home'
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
        redirect_to live_studio.list_station_workstation_video_courses_path(@workstation, cate: 'completed'), notice: notice
      else
        render :edit, layout: 'v1/manager_home'
      end
    end

    def publish
      @video_course.publish! if @video_course.completed?
      redirect_to live_studio.list_station_workstation_video_courses_path(@workstation, cate: 'completed'), notice: I18n.t('live_studio.notices.video_course.published')
    end

    private

    def find_course
      @video_course = LiveStudio::VideoCourse.find(params[:id])
    end

    def set_video_course_and_check
      @video_course = @workstation.live_studio_video_courses.find(params[:id])
      redirect_to live_studio.list_station_workstation_video_courses_path(@workstation), notice: '视频课状态不正确.' unless %w(confirmed completed).include?(@video_course.status)
    end

    def video_course_params
      params.require(:video_course).permit(:name, :grade, :description, :objective, :suit_crowd, :sell_type, :price, :teacher_percentage,
                                           video_lessons_attributes: [:id, :tastable])
    end
  end
end
