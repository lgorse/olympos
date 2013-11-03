module SessionsHelper
	include LoginHelper, FacebookHelper

	def sign_in_user
		session[:user_id] = @user.id
		set_fb_access_token if @user.facebook?
	end

	def valid_user_signin
		sign_in_user
		redirect_to home_user_path(@user)
	end

	def signed_in?
		session[:user_id].present?
	end

	def sign_out_user
		reset_session
		cookies.clear
		redirect_to root_path and return
	end


	def authenticate
		begin
			@current_user = User.find(session[:user_id])
			
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
		@user = User.find_by_fb_id(request['user_id'])
		if @user&&@user.facebook?
			valid_user_signin
		else
			redirect_to fb_new_user_path
		end

	end


end
