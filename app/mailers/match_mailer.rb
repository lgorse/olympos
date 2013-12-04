class MatchMailer < ActionMailer::Base
  include MailerHelper
  default from: DEFAULT_FROM

  def match_notify(match)
    @sender = match.player1
    @recipient = match.player2
    @host = parse_host
    @subject = "#{@sender.firstname} logged your match together"
    mail(:to => @recipient.email, :subject => @subject)

  end

end
