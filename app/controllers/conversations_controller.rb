class ConversationsController < ApplicationController
	include ConversationsHelper

	before_filter :authenticate
	before_filter :get_mailbox

	def index
		@conversations = Conversation.participant(@current_user)
	end

	def show
		@conversation = Conversation.find(params[:id])

	end

	def update
		@conversation = Conversation.find(params[:id])
		@receipt = @current_user.reply_to_conversation(@conversation, params[:body])
		if @receipt.errors.blank?
			redirect_to @conversation
		else
			render 'show'
		end

	end
end
