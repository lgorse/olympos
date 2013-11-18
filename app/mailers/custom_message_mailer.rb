class CustomMessageMailer < ActionMailer::Base
  include MailerHelper

  default from: DEFAULT_FROM

  def send_email(receipt, recipient)
  	@message = receipt.message
  	@sender = @message.sender
  	@recipient = recipient
  	@conversation = @message.conversation
  	@host = parse_host
  	mail(:to => @recipient.email, :subject => "#{@sender.firstname} sent you a message on #{APP_NAME}")
  end


end
