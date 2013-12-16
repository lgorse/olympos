class MatchMailer < ActionMailer::Base
  include MailerHelper
  helper :matches
  helper :users


  default from: DEFAULT_FROM

  def match_notify(match)
  	@match = match
    @user = match.player1
    @recipient = match.player2
    @host = parse_host
    @subject = "#{@user.firstname} logged your match together"
    mail(:to => @recipient.email, :subject => @subject)

  end

end
