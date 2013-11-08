class UsersController < ApplicationController
	include UsersHelper

	before_filter :authenticate, :only => [:home, :show, :details, :change_picture, :edit]
	

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
			parse_fb_request
			new_user_from_FB
		end
	end

	def home
		

	end

	def index

	end

	def details
		@user = @current_user
		@user.set_fb_large_pic(@graph) if @user.facebook? && @graph
	end

	def change_picture
		@user = params[:id]
		print params[:from_url]


	end

	def update
		@current_user = User.find(params[:id])
		if @current_user.update_attributes(params[:user])
			respond_to do |format|
				format.html{
					print "A"*1000
					if params[:redirect_url]
						redirect_to params[:redirect_url]
					else
						redirect_to @current_user
					end
				}
				format.js
			end						
		end

	end

	def edit
	end

	def show
		if params[:id] == @current_user.id
			@user = @current_user
		else
			@user = User.find(params[:id])
		end
		@user.set_fb_large_pic(@graph) if @user.facebook? && @graph
		@full_name = @user.firstname + " " +  @user.lastname
	end

end
