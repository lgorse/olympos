require 'spec_helper'

describe FairnessRatingsController do

	describe "POST 'create'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@match = FactoryGirl.create(:match, :player1_id  => @user.id)
			test_sign_in(@user)
			@attr = {:rated_id => @match.player2.id,
					 :match_id => @match.id, :rating => 4}
		end

		it 'should create a new fairness rating' do
			lambda do
				post :create, :fairness_rating => @attr
			end.should change(FairnessRating, :count).by(1)

		end


	end

end
