class MessagesController < ApplicationController
	include ConversationsHelper

	before_filter :authenticate
	before_filter :get_mailbox

	def new
		@message = Message.new

	end

	def create
		@recipients = params[:message][:recipient_id].split(',').map{|id| User.find(id)}

		if @conversation = conversation_already_exists

			@receipt = @current_user.reply_to_conversation(@conversation, params[:message][:body])
		else
			@receipt = @current_user.send_message(@recipients, params[:message][:body], 'filler')
		end
		if @receipt
			@current_user.message_email_notify(@receipt, @recipients)
			redirect_to @receipt.conversation
		else
			render 'new'
		end

	end
end
