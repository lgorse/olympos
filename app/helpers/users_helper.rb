module UsersHelper

	def save_manual_user
		if @current_user.save
			new_user_success
		else
			render 'new'
		end
	end

	def new_user_from_FB
		parse_fb_request
		fb_attr = @signed_request['registration']
		
		@attr = {:firstname => fb_attr['first_name'], :lastname => fb_attr['last_name'],
			:email => fb_attr['email'], :gender => fb_attr['gender'],
			:birthdate => Date.strptime(fb_attr['birthday'], "%m/%d/%Y"), :fb_id => @signed_request['user_id'],
			:password => 'randompassword'}

		@current_user = User.where(:fb_id => @signed_request['user_id']).first_or_initialize(@attr.merge(:signup_method => FACEBOOK))
	end

	def save_fb_user
		if @current_user.save
			new_user_success
		else
			render 'fb'
		end
	end

	def new_user_success
		sign_in_user
		render 'users/details'
	end
end
