class FriendshipMailer < ActionMailer::Base
  default from: DEFAULT_FROM

  def friend_request(friendship)
  	@friender = friendship.friender
  	@friended = friendship.friended
  	@subject = "#{@friender.firstname} friended you"
  	mail(:to => @friended.email, :subject => @subject)
  end
end
