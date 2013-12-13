class EmailWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 3

	def perform(email_type_constant, object_id)
		case email_type_constant
		when MATCH
			MatchMailer.match_notify(Match.find(object_id)).deliver
		when INVITATION
			InviteMailer.invite_email(Invitation.find(object_id)).deliver
		when FRIENDSHIP
			FriendshipMailer.friend_request(Friendship.find(object_id)).deliver
		else
		end
	end
end