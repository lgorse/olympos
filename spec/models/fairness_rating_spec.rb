# == Schema Information
#
# Table name: fairness_ratings
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  rater_id   :integer
#  rated_id   :integer
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe FairnessRating do

	describe "validations" do
		before(:each) do
			@match = FactoryGirl.create(:match)
			@attr = {:match_id => @match.id, :rater_id => @match.player1_id,
					 :rated_id => @match.player2_id, :rating => 4}

		end

		it "should have a match id" do
			rating = FairnessRating.new(@attr.merge(:match_id => ''))
			rating.should_not be_valid
		end

		it "should have a rater id" do
			rating = FairnessRating.new(@attr.merge(:rater_id => ''))
			rating.should_not be_valid
		end

		it "should have a rated id" do
			rating = FairnessRating.new(@attr.merge(:rated_id => ''))
			rating.should_not be_valid
		end

		describe "rating" do

			it 'should have a rating' do
				rating = FairnessRating.new(@attr.merge(:rating => ''))
				rating.should_not be_valid
			end

			it 'should not exceed 5' do
				rating = FairnessRating.new(@attr.merge(:rating => 6 ))
				rating.should_not be_valid
			end

			it "should be greater than 0" do
				rating = FairnessRating.new(@attr.merge(:rating => 0 ))
				rating.should_not be_valid
			end

		end

	end

	describe "associations" do
		before(:each) do
			@rater = FactoryGirl.create(:user)
			@rated = FactoryGirl.create(:user)
			@match = FactoryGirl.create(:match, :player1_id => @rater.id,
				:player2_id => @rated.id)
			@attr = {:match_id => @match.id, :rater_id => @rater.id, :rated_id => @rated.id, :rating => 4}
			@rating = FairnessRating.new(@attr)
		end

		describe "match " do

			it "should respond to a match association" do
				@rating.should respond_to(:match)
			end

			it "should return the correct match" do
				@rating.match.id.should == @match.id
			end

			it "should not allow a fairness rating if the match does not belong to the rater and rated" do
				new_match = FactoryGirl.create(:match, :player1_id => @rater.id)
				new_rating = FairnessRating.new(@attr.merge(:match_id => new_match.id))
				new_rating.should_not be_valid
			end

		end

		describe "rater" do

			it "should respond to a rater association" do
				@rating.should respond_to(:rater)

			end

			it "should return the rater" do
				@rating.rater.id.should == @rater.id
			end

		end

		describe 'rated' do

			it "should respond to a rated association" do
				@rating.should respond_to(:rated)
			end

			it "should return the rated" do
				@rating.rated.id.should == @rated.id

			end
		end

		describe "raters" do
			it "should respond to a raters associations" do
				@rating.should respond_to(:raters)
			end

		end

		describe "dependencies" do
			before(:each) do
				@match = FactoryGirl.create(:match)
				@user = @match.player1
				@rating = @user.rate_fairness(@match.player2.id, @match.id, 4)
			end

			it "should be destroyed if the user is destroyed" do
				@user.destroy
				FairnessRating.find_by_id(@rating).should be_blank
			end

			it "should be destroyed if the match is destroyed" do
				@match.destroy
				FairnessRating.find_by_id(@rating).should be_blank
			end

		end

	end
end
