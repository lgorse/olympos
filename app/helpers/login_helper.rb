module LoginHelper

	def login_manual_user
		@user = User.find_by_email(params[:session][:email].downcase)
		if @user && @user.authenticate(params[:session][:password])
			valid_user_signin
		else
			render 'sessions/new'
			flash.now[:error] = "invalid e-mail or password"
		end
	end

	def login_fb_user
		request = decode_data(params['signed_request'])
		print request['access_token']
		@user = User.find_by_fb_id(request['user_id'])
		if @user
			valid_user_signin
		else
			redirect_to fb_new_user_path
		end

	end

end