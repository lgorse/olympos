module MailerHelper

	def parse_host
		if Rails.env == 'production'
			Addressable::URI.parse(FULL_ROOT).host  		
		else
			Addressable::URI.parse(FULL_ROOT).host+':8080'
		end
	end
end