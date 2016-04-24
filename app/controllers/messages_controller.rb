class MessagesController < ApplicationController
  layout "application"

  def index
    @customized_course = CustomizedCourse.includes(messages: :implementable).find(params[:customized_course_id])
  end

  def create
    @customized_course = CustomizedCourse.find(params[:customized_course_id])
    options = {}
    message_type = params[:message_type]
    #文字消息
    if message_type == 'text_message' and params[:text_message_content].length > 0
      options = {
          type: :text,
          params: {
              content: params[:text_message_content],
              author_id: current_user.id
          }
      }
    #上传了图片 图片消息
    elsif message_type == 'image_message'
      options = {
          type: :images,
          params: {
              image_ids: params[:image_ids],
              author_id: current_user.id
          }
      }
    end

    message = MessageServer::CreateMessage.new(options).call
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
