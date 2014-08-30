class MessagesController < ApplicationController
	def index
		@messages = Message.where(receiver_id:current_user.id).order(created_at: :asc)
	end
end
