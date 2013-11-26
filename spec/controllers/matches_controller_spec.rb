require 'spec_helper'

describe MatchesController do

	describe "GET New" do

		describe "authentication" do
			before(:each) do
				@user = FactoryGirl.create(:user)
			end

			describe "if successful" do

				it 'should be successful' do
					test_sign_in(@user)
					get :new
					response.should be_successful
				end

				
			end

			describe 'if failed' do

				it "should redirect ot the root path" do
					get :new
					response.should redirect_to root_path
				end

			end

		end

	end

	describe "POST 'create'" do
		before(:each) do
			@winner = FactoryGirl.create(:user)
			@loser = FactoryGirl.create(:user)
			test_sign_in(@winner)
		end

		describe "if successful" do
			before(:each) do
				@attr = {:player1_id => @winner.id, :player2_id => @loser.id,
						 :player1_score=>{"0"=>"11", "1"=>"12", "2"=>"11", "3"=>"", "4"=>""}, 
						 :player2_score=>{"0"=>"4", "1"=>"10", "2"=>"4", "3"=>"", "4"=>""}
						}

			end

			it 'should create a new match' do
				lambda do
					post :create, :match => @attr
				end.should change(Match, :count).by(1)
			end

		end

		describe "if failed" do

			it "should render the new template" do

			end

		end

	end

end
