class FriendshipMailer < ActionMailer::Base
	include MailerHelper

  default from: DEFAULT_FROM

  def friend_request(friendship)
  	@user = friendship.friender
  	@friended = friendship.friended
  	@subject = "#{@user.firstname} wants to connect on #{APP_NAME}"
  	@host = parse_host
  	
  	mail(:to => @friended.email, :subject => @subject)
  end
end
