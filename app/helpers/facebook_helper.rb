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
		fb_att = signed_request['registration']
		@attr = {:firstname => fb_attr['first_name'], :lastname => fb_attr['last_name'],
				:email => fb_attr['last_name'], :gender => fb_attr['gender'],
				:birthdate => fb_attr['birthday'], :fb_id => signed_request['user_id']}
		User.new(@attr)
	end

end
