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
    @message = PushMessage.new(message_params.merge(status: :init,display_type: :notification))
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

  private
  def message_params
    params.require(:push_message).permit(
      %w(ticker title text after_open url activity custom start_time expire_time later_expire_time description play_vibrate play_lights send_type play_sound customer assign_value)
    )
  end
end
