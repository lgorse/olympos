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
				concat link_to "Nag", new_message_path(:recipient_id => match.player2_id, 
													 :recipient_fullname => match.opponent(@current_user).fullname,
													 :message_type => NAG), :remote => true

			else 
				concat "#{match.opponent(@current_user).firstname} wants you to confirm this match"
			end
			end
		end
	end

	def win_or_lose(match, user)
		if match.winner == user
           "#{you_for_current_user(@user)} won against "
          else
            "#{you_for_current_user(@user)} lost against "
          end
	end
end
