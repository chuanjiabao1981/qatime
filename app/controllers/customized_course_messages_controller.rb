class CustomizedCourseMessagesController < ApplicationController
  include QaMessage
  layout "application"
  respond_to :html

  include QaCommonFilter
  __add_last_operator_to_param(:customized_course_message)


  def new
    @customized_course_message = @customized_course_message_board.customized_course_messages.build
  end


  def create
    @customized_course_message =
        @customized_course_message_board.customized_course_messages.build(params[:customized_course_message].permit!)
    @customized_course_message.author = current_user
    if @customized_course_message.save
      flash[:success] = I18n.t('flash.customized_course_message.create.success')
    end
    respond_with @customized_course_message
  end

  def show
    customized_course_message_show_prepare

  end

  def edit

  end

  def update
    if @customized_course_message.update_attributes(params[:customized_course_message].permit!)
      flash[:success] = I18n.t('flash.customized_course_message.update.success')
    end
    respond_with @customized_course_message
  end

  def destroy
    @customized_course_message.destroy
    respond_with @customized_course_message.customized_course_message_board
  end

  private
  def current_resource
    if params[:customized_course_message_board_id]
      @customized_course_message_board = CustomizedCourseMessageBoard.find(params[:customized_course_message_board_id])
      r                                = @customized_course_message_board
    end
    if params[:id]
      @customized_course_message       = CustomizedCourseMessage.find(params[:id])
      r                                = @customized_course_message
    end
    r
  end
end
