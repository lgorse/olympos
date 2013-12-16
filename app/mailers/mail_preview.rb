class MailPreview < MailView

	def message
		mail = CustomMessageMailer.send_email(Receipt.last, User.last)
	end

	def invite
		mail = InviteMailer.invite_email(Invitation.last)
	end

	def friendship
		mail = FriendshipMailer.friend_request(Friendship.find_by_friender_id(34))

	end

	def match
		mail = MatchMailer.match_notify(Match.last)
	end

end