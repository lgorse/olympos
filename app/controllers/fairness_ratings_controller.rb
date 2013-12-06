class FairnessRatingsController < ApplicationController
	before_filter :authenticate

	
	def new
		@rating = FairnessRating.new
		@match = @current_user.matches.last
	end

	def create
		print params
		@rating = FairnessRating.new(params[:fairness_rating].merge(:rater_id => @current_user.id))
		@rating.save
	end
end
