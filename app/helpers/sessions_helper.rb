module SessionsHelper
	include LoginHelper, FacebookHelper

	def sign_in_user(user)
		session[:user_id] = user.id
	end

	def valid_user_signin
		sign_in_user(@user)
		redirect_to home_user_path(@user)
	end

	def signed_in?
		session[:user_id]
	end

	def sign_out_user
		reset_session
		redirect_to root_path and return
	end

	def authenticate
		begin
			@current_user = User.find(session[:user_id])
			parse_facebook_cookies if @current_user.facebook?
		rescue
			sign_out_user
		end
	end

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
