class UsersController < ApplicationController
	include UsersHelper

	before_filter :authenticate, :only => [:home]
	

	def new
		@user = User.new
	end

	def fb
		@user = User.new
	end


	def create
		if params[:user]
			@user = User.new(params[:user].merge(:signup_method => EMAIL))
			save_manual_user
		elsif params['signed_request']
			new_user_from_FB
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
			#parse_facebook_cookies if @current_user.facebook?
		rescue
			sign_out_user
		end
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
