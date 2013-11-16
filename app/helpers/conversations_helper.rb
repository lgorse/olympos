module ConversationsHelper

	def get_mailbox
		@mailbox = @current_user.mailbox
	end
end
