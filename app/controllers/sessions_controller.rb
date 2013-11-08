class SessionsController < ApplicationController


	def new
		redirect_to home_users_path if session[:user_id]
	end

	def create
		if params[:session]
			login_manual_user
		elsif params['signed_request']
			login_fb_user
		end
	end

	def destroy
		sign_out_user
	end
end
