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

	def fb_graph
		if @current_user.facebook?
			begin
				if cookies["fbsr_#{FACEBOOK_CONFIG["app_id"]}"]
					parse_fb_cookie
				elsif params['signed_request']
					parse_fb_request
				end
			rescue
				print "ERROR #{e.message}"
			end
		end

	end

	
	def parse_fb_cookie
		@facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		@access_token = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)		
	end


	def parse_fb_request
		@signed_request =  Koala::Facebook::OAuth.new.parse_signed_request(params['signed_request'])
		@graph = Koala::Facebook::GraphAPI.new(@signed_request['oauth_token'])	
	end


end