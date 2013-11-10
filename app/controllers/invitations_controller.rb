class InvitationsController < ApplicationController

	def show
		@invitation = Invitation.find(params[:id])
		 if @invitation.email == params[:email]
		 	@invitation.clicked  = true
		 	@invitation.save
		 	redirect_to root_path
		 else
		 	redirect_to root_path

		 end
	end

	def create
		@invitation = Invitation.new(params[:invitation])
		@invitation.save
		render 'new'
	end
end
