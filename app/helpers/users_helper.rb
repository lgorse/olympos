module UsersHelper

	def save_manual_user
		if @user.save
			save_user_success
		else
			render 'new'
		end
	end

	def new_user_from_FB
		@signed_request =  decode_data(params['signed_request'])
		fb_attr = @signed_request['registration']
		@attr = {:firstname => fb_attr['first_name'], :lastname => fb_attr['last_name'],
			:email => fb_attr['email'], :gender => fb_attr['gender'],
			:birthdate => Date.strptime(fb_attr['birthday'], "%m/%d/%Y"), :fb_id => @signed_request['user_id'],
			:password => 'randompassword'}
			User.where(:fb_id => @signed_request['user_id']).first_or_initialize(@attr.merge(:signup_method => FACEBOOK))
	end

	def save_fb_user
		if @user.save
			if @user.fb_id == @signed_request['user_id'].to_i
				save_user_success
			else
				sign_out_user
			end
		else
			render 'fb'
		end
	end

	def save_user_success
		sign_in_user(@user)
		redirect_to details_user_path(@user)
	end
end
