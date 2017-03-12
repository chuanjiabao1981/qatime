require_dependency "live_studio/station/application_controller"

module LiveStudio
  class Station::CoursesController < Station::ApplicationController
    skip_before_action :authorize, only: [:send_qr_code]
    before_action :find_course, only: [:send_qr_code]

    def index
      @courses = LiveStudio::Course.includes(:teacher)
      @courses = @courses.where(course_search_params) if course_search_params.present?
      @courses = @courses.where("live_studio_courses.sell_and_platform_percentage > ?", @workstation.platform_percentage)

      case params[:sell_percentage_range].to_s
        when 'low'
          @courses = @courses.where("sell_percentage <= ?", 5)
        when 'middle'
          @courses = @courses.where(sell_percentage: [5,10])
        when 'high'
          @courses = @courses.where("sell_percentage > ?", 10)
        else
          @courses
      end
      @courses = @courses.where(workstation_id: params[:select_workstation_id]) if params[:select_workstation_id].present?
      @courses = @courses.where(status: LiveStudio::Course.statuses.values_at(:published, :teaching)) if params[:status].blank?
      @courses = @courses.where(status: LiveStudio::Course.statuses[params[:status].to_s]) if params[:status].present?
      @courses = @courses.paginate(page: params[:page])
    end

    # 发送二维码
    def send_qr_code
      # qr_code_url = 'http://qatime-testing.oss-cn-beijing.aliyuncs.com/qrcode/598c14c7c6d5c1ad4b0e910901e3c8b8.png'
      # open(qr_code_url) do |f|
      #   send_data f.read, type: "#{f.content_type};charset=utf-8;header=present", filename: "#{@course.name.to_s}.png", disposition: 'attachment'
      # end
      code = @workstation.coupon.try(:code)
      return render text: I18n.t('view.live_studio/courses.no_coupon_code') if code.blank?

      qr_code_url = @course.generate_qrcode_by_coupon(code)
      image = URI(qr_code_url).read
      send_data image, type: "#{image.content_type};charset=utf-8;header=present", filename: "#{@course.name.to_s}.png", disposition: 'attachment'
    end

    private

    def course_search_params
      params.permit(:subject, :grade).select {|_k, v| v.present? }
    end

    def find_course
      @course = LiveStudio::Course.find(params[:id])
    end
  end
end
