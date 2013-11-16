class CustomMessageMailer < ActionMailer::Base
  default from: DEFAULT_FROM

  def send_email(receipt, recipient)
  	@message = receipt.message
  	@recipient = recipient
  	mail(:to => "olympos.help@gmail.com", :subject => "Hi bro what is up?")
  end


end
