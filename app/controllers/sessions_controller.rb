class SessionsController < ApplicationController


	def new
		redirect_to home_user_path(session[:user_id]) if session[:user_id]

	end

	def create
		@user = User.find_by_email(params[:session][:email].downcase)
		if @user && @user.authenticate(params[:session][:password])
			sign_in_user(@user)
			redirect_to home_user_path(@user)
		else
			render 'sessions/new'
			flash.now[:error] = "invalid e-mail or password"
		end

	end

	def destroy
		sign_out_user
	end
end
