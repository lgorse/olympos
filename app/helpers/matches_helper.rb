module MatchesHelper

	def set_winner_id
		case params[:match][:winner_id]
		when "true"
			winner_id = @current_user.id
		when "false"
			winner_id = params[:match][:player2_id]
		else winner_id = ''
		end
		winner_id
	end
end
