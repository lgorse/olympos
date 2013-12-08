class FairnessRatingsController < ApplicationController
	
	before_filter :authenticate

	
	def new
		@rating = FairnessRating.new
		@match = @current_user.matches.last
	end

	def create
		
		@rating = FairnessRating.new(params[:fairness_rating].merge(:rater_id => @current_user.id))
		@rating.save
	end

	def update
		@rating = FairnessRating.find(params[:id])
		if @rating.update_attributes(params[:fairness_rating])
		else
			flash[:error] = "Something went wrong"
		end
	end

	def about
	end
end
