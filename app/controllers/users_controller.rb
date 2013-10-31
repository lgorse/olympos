class UsersController < ApplicationController

	before_filter :authenticate, :only => [:home, :details]

	def new
		@user = User.new
	end

	def create
		if params[:user]
			@user = User.new(params[:user].merge(:signup_method => EMAIL))
		elsif params['signed_request']
			@user = new_user_from_FB
		end
		if @user.save
			sign_in_user(@user)
			redirect_to details_user_path(@user)
		else
			render 'new'
		end
	end

	def home

	end

	def details
		@user = @current_user
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to home_user_path(@user) if params{:details_form}
		else
			
		end
	end

end
