class ConversationsController < ApplicationController
	include ConversationsHelper

	before_filter :authenticate
	before_filter :get_mailbox

	def index
		@conversations = Conversation.participant(@current_user)
		@conversation = @conversations.first
	end

	def show
		@conversation = Conversation.find(params[:id])
		@conversation.mark_as_read @current_user
	end

	def update
		@conversation = Conversation.find(params[:id])
		@participants = @conversation.participants.reject{|user| user.id == @current_user.id}
		@receipt = @current_user.reply_to_conversation(@conversation, params[:body])
		if @receipt.errors.blank?
			@current_user.message_email_notify(@receipt, @participants)
			redirect_to @conversation
		else
			render 'show'
		end

	end
end
