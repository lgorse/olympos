class UsersController < ApplicationController
	include UsersHelper

	before_filter :authenticate, :only => [:home, :show, :details]
	

	def new
		@current_user = User.new
	end

	def fb
		@current_user = User.new
	end


	def create
		if params[:user]
			@current_user = User.new(params[:user].merge(:signup_method => EMAIL))
			save_manual_user
		elsif params['signed_request']
			new_user_from_FB
			save_fb_user
		end
	end

	def home
		print session[:user_id]
		
		

	end

	def index
	
	end

	def details

	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to home_user_path(@user) if params{:details_form}
		else
			
		end
	end

	def show
		if params[:id] == @current_user.id
			@user = @current_user
		else
			@user = User.find(params[:id])
		end
		@user.set_fb_large_pic(@graph)
	end

end
