class MatchesController < ApplicationController

	before_filter :authenticate

	def new
		@match = Match.new
	end

	def create
	end
end
