module ConversationsHelper

	def get_mailbox
		@mailbox = @current_user.mailbox
	end

	def conversation_already_exists
		Conversation.participant(@current_user).select{|conv| conv.participants.collect(&:id).sort == (@recipients+[@current_user]).collect(&:id).sort}.first
	end

	def conversation_participant_list
		list = @conversation.participants.collect {|user| link_to user.firstname, user}.join(" , ")
		simple_format word_wrap(list, :line_width => 70)
	end
end
