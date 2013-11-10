class InviteMailer < ActionMailer::Base
  default from: "olympos.help@gmail.com"

  def invite_email(invitation)
	@invitation = invitation
	@inviter = @invitation.inviter
	@first_name = @inviter.firstname
	@subject = "#{@inviter.firstname} invited you to join #{APP_NAME}"
	@host = parse_host
	mail(:to => @invitation.email, :subject => @subject)

  end

  def parse_host
  	if Rails.env == 'production'
  		Addressable::URI.parse(FULL_ROOT).host  		
  	else
  	Addressable::URI.parse(FULL_ROOT).host+':8080'
	end

  end
end
