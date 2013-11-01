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

	def new_user_from_FB
		print params['signed_request']
		signed_request =  decode_data(params['signed_request'])
		fb_attr = signed_request['registration']
		@attr = {:firstname => fb_attr['first_name'], :lastname => fb_attr['last_name'],
			:email => fb_attr['email'], :gender => fb_attr['gender'],
			:birthdate => Date.strptime(fb_attr['birthday'], "%m/%d/%Y"), :fb_id => signed_request['user_id'],
			:password => 'randompassword'}
		User.where(:fb_id => signed_request['user_id']).first_or_initialize(@attr.merge(:signup_method => FACEBOOK))
	end

	def parse_facebook_cookies
		@facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		facebook_id = @facebook_cookies['user_id'].to_i
		if @current_user.fb_id == facebook_id
			@access_token = @facebook_cookies["access_token"]
			@graph = Koala::Facebook::GraphAPI.new(@access_token)
		else
			sign_out_user
		end
		
	end

end
