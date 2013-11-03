class UsersController < ApplicationController
	include UsersHelper

	before_filter :authenticate, :only => [:home]
	

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
		begin
			@current_user = User.find(session[:user_id])
		rescue
			sign_out_user
		end
		
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to home_user_path(@user) if params{:details_form}
		else
			
		end
	end

end
