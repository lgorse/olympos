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
				get_graph_from_cookie
			rescue => e
				print "ERROR #{e.message}"
			end
		end

	end

	
	def parse_fb_cookie
		@facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		@access_token = @facebook_cookies["access_token"]
		create_fb_cookie(@access_token, Time.at(@facebook_cookies["issued_at"].to_i + @facebook_cookies["expires"].to_i))
		@graph = Koala::Facebook::GraphAPI.new(@access_token)		
	end


	def parse_fb_request
		@signed_request =  Koala::Facebook::OAuth.new.parse_signed_request(params['signed_request'])
		@access_token = @signed_request['oauth_token']
		create_fb_cookie(@access_token, Time.at(@signed_request["expires"].to_i))
		@graph = Koala::Facebook::GraphAPI.new(@access_token)		
	end

	def create_fb_cookie(access_token, expiration)
		cookies[:fb_access] = {:value => access_token, :expires => expiration}
	end

	def get_graph_from_cookie
		if fb_cookie_valid?
			@access_token = cookies[:fb_access]
			@graph = Koala::Facebook::GraphAPI.new(@access_token)
		else
			@new_access = Koala::Facebook::OAuth.new.exchange_access_token(cookies[:fb_access])
			@graph = Koala::Facebook::GraphAPI.new(@new_access)
		end
	end

	def fb_cookie_valid?
		cookies[:fb_access]
	end


end