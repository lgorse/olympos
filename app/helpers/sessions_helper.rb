module SessionsHelper
	include LoginHelper, FacebookHelper

	def sign_in_user
		session[:user_id] = @current_user.id
		
	end

	def valid_user_signin
		sign_in_user
		parse_fb_cookie
		redirect_to home_user_path(@current_user)
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
			fb_graph
			@current_user.set_fb_square_pic(@graph)
		rescue
			sign_out_user
		end
	end

	def login_manual_user
		@current_user = User.find_by_email(params[:session][:email].downcase)
		if @current_user && @current_user.authenticate(params[:session][:password])
			valid_user_signin
		else
			render 'sessions/new'
			flash.now[:error] = "invalid e-mail or password"
		end
	end

	def login_fb_user
		parse_fb_cookie
		@current_user = User.find_by_fb_id(@facebook_cookies['user_id'])
		if @current_user&&@current_user.facebook?
			valid_user_signin
		else
			redirect_to fb_new_user_path
		end

	end


end
