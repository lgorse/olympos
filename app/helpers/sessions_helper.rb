module SessionsHelper
	include LoginHelper

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
		rescue
			sign_out_user
		end
	end


end
