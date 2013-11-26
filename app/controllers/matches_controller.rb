class MatchesController < ApplicationController

	before_filter :authenticate

	def new
		@match = Match.new
	end

	def create
		@player1_score = params[:match][:player1_score].map {|key, value| value.to_i unless value.blank?}.compact
		@player2_score = params[:match][:player2_score].map {|key, value| value.to_i unless value.blank?}.compact
		@match = Match.create(params[:match].merge(:player1_score => @player1_score, :player2_score => @player2_score, :player1_confirm => true))
	end
end
