class MessageEmailWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 3

	def perform(receipt_id, recipient_id)
		receipt = Receipt.find(receipt_id)
		recipient = User.find(recipient_id)
		CustomMessageMailer.send_email(receipt, recipient).deliver
	end
end