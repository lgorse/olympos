class ClubsController < ApplicationController

	before_filter :authenticate

	def new
		@club = Club.new

	end

	def create
		@club = Club.new(params[:club])
		if @club.save
			redirect_to new_club_path, flash: {success: "New club saved"}
		else
			render 'new'
		end
	end

	def destroy
	end

	def edit
		@club = Club.find(params[:id])
	end

	def update
		@club = Club.find(params[:id])
		if @club.update_attributes(params[:club])
			
			redirect_to new_club_path, flash: {success: "Club updated"}
		else
			render 'new'
		end


	end
end
