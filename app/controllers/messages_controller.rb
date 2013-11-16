class MessagesController < ApplicationController
	include ConversationsHelper

	before_filter :authenticate
	before_filter :get_mailbox

	def new
		@message = Message.new

	end

	def create
		@recipient = User.find(params[:message][:recipient_id])
		if @conversation = Conversation.participant(@current_user).participant(@recipient).first
			@receipt = @current_user.reply_to_conversation(@conversation, params[:message][:body])
		else
			@receipt = @current_user.send_message(@recipient, params[:message][:body], 'filler')
		end
		if @receipt
			@current_user.message_email_notify(@receipt, @recipient)
			redirect_to @receipt.conversation
		else
			render 'new'
		end

	end
end
