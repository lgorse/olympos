module MessagesHelper

	def message_prefill(message_type)
		case message_type.to_i
		when NAG
			@recipient = User.find(params[:recipient_id]) if params[:recipient_id]
			"Hi #{@recipient.fullname}! Don't forget to confirm your match with #{@current_user.fullname}!" 
		else
			''
		end
	end
end
