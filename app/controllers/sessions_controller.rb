class SessionsController < ApplicationController


	def new

	end

	def create
		@user = User.find_by_email(params[:session][:email].downcase)
		if @user && @user.authenticate(params[:session][:password])
			sign_in_user(@user)
			redirect_to users_path
		else
			render 'sessions/new'
			flash.now[:error] = "invalid e-mail or password"
		end

	end

	def destroy
		sign_out_user
	end
end
