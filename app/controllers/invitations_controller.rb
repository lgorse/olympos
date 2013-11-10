class InvitationsController < ApplicationController

	before_filter :authenticate, :only => [:new, :create]

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
end
