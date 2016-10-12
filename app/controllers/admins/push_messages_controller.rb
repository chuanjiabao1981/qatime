class Admins::PushMessagesController < ApplicationController

  respond_to :html
  layout "admin_home"

  def index
    @messages = PushMessage.all.order(id: :desc).page(params[:page])
  end

  def new
    @message = PushMessage.new
  end

  def edit
    @message = PushMessage.find params[:id]
  end

  def create
    @message = PushMessage.new(message_params.merge(status: :init))
    @message.creator = current_user
    if @message.save
      redirect_to admins_push_messages_path
    else
      render :new
    end
  end

  def update
    @message = PushMessage.find params[:id]
    if @message.update(message_params)
      redirect_to admins_push_messages_path
    else
      render :edit
    end
  end

  def push
    @message = PushMessage.find params[:id]
    PushWorker.perform_async(@message)
    @message.pushing!
    redirect_to admins_push_messages_path
  end

  private
  def message_params
    params.require(:push_message).permit(
      %w(push_type alias_type alias filter display_type ticker title text after_open url activity custom start_time expire_time production_mode)
    )
  end
end
