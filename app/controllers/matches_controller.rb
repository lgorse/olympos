class MatchesController < ApplicationController
	include MatchesHelper

	before_filter :authenticate

	def new
		@match = Match.new
	end

	def create
		#@player1_score = params[:match][:player1_score].map {|key, value| value.to_i unless value.blank?}.compact
		#@player2_score = params[:match][:player2_score].map {|key, value| value.to_i unless value.blank?}.compact
		@winner_id = set_winner_id
		@match = Match.new(params[:match].merge(:player1_score => @player1_score, 
			:player2_score => @player2_score, 
			:player1_confirm => true,
			:winner_id => @winner_id))
		if @match.save
			redirect_to matches_path
		else
			render 'new'
		end
	end

	def index
		#@matches = @current_user.matches
		#by_owner = Match.send(:sanitize_sql_array, [ 'case when player2_id = %d then 0 else 1 end', @current_user.id ])
		@matches = @current_user.ordered_matches

	end

	def destroy
		@match = Match.find(params[:id])
		if @match.players.include?(@current_user)
			@match.destroy
		else
			flash[:failure] = "Cannot destroy someone else\'s match"
		end
		redirect_to matches_path
	end

	def update
		@match = Match.find(params[:id])
		if @match.player2_id == @current_user.id
			if @match.update_attributes(params[:match])
			else
				flash[:error] = "Something went wrong"
			end
		else
			flash[:error] = "Cannot destroy someone else\'s match"
		end
		redirect_to matches_path

	end


end
