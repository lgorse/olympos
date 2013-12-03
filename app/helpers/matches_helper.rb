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

	def prompt_text(match)
		unless match.confirmed?
			content_tag(:div, :class => "prompt_text") do
			case match.player1_id
			when @current_user.id				
				concat "#{match.opponent(@current_user).firstname} has not confirmed yet. "  
				concat link_to "Nag", match.opponent(@current_user)

			else 
				concat "#{match.opponent(@current_user).firstname} wants you to confirm this match"
			end
			end
		end
	end
end
