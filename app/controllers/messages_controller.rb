class MessagesController < ApplicationController
  layout "application"

  def index
    @customized_course = CustomizedCourse.find(params[:customized_course_id])
    @messages = @customized_course.messages.includes(:implementable).order('created_at desc').paginate(page: params[:page])
  end

  def create
    @customized_course = CustomizedCourse.find(params[:customized_course_id])
    message = MessageService::DispatchMessage.new(current_user.id, params).call
    @customized_course.messages << message
    redirect_to customized_course_messaging_index_path(@customized_course)
  end

  #上传图片
  def upload_image
    image_upload = params[:file]

    uploader = PictureUploader.new
    File.open(image_upload.path) do |file|
      uploader.store!(file)
    end

    oss_url = uploader.url
    image = Message::Image.new
    image.name = oss_url
    image.save

    render json: image
  end
end
