class InvitationsController < ApplicationController
	include InvitationsHelper

	before_filter :authenticate, :only => [:new, :create, :ussquash]

	def show
		@invitation = Invitation.find(params[:id])
		 if @invitation.email == params[:email]
		 	@invitation.clicked  = true
		 	@invitation.save
		 	sign_out_user
		 else
		 	sign_out_user
		 end
	end

	def create
		@invitation = Invitation.new(params[:invitation])
		if @invitation.save
			@invitation = Invitation.new
		end
		render 'new'
	end

	def new
		@invitation = Invitation.new

	end

	def ussquash
		@us_squash_id = find_us_squash_profile
		if @us_squash_id == "multiple results"

		else
			get_last_us_squash_opponent
		end
		
		
		
		

	end
end
