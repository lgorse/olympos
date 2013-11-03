module FacebookHelper

	def base64_url_decode str
		encoded_str = str.gsub('-','+').gsub('_','/')
		encoded_str += '=' while !(encoded_str.size % 4).zero?
		Base64.decode64(encoded_str)
	end

	def decode_data str
		encoded_sig, payload = str.split('.')
		data = ActiveSupport::JSON.decode base64_url_decode(payload)
	end

	
	def set_fb_access_token
		begin
			@facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
			facebook_id = @facebook_cookies['user_id'].to_i
			@access_token = @facebook_cookies["access_token"]
			expiration_time = Time.at(@facebook_cookies["issued_at"].to_i+@facebook_cookies["expires"].to_i)
			cookies["fbtk"] = {:value => @access_token, :expires => expiration_time}
			return facebook_id
		rescue Exception => e
			print "ERROR #{e.message}"
		end
	end



	def parse_facebook_cookies
		if @current_user.facebook?

		end

		@facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		facebook_id = @facebook_cookies['user_id'].to_i
		if user.fb_id == facebook_id
			print "A"*50
			
			#expires = @facebook_cookies["expires"]
			#issued = @facebook_cookies["issued"]
			@graph = Koala::Facebook::GraphAPI.new(@access_token)
		else
			sign_out_user
		end		
	end

end
