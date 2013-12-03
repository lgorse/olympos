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
			@attr = {:player1_id => @winner.id, :player2_id => @loser.id,
						 :play_date => 1.day.ago.to_date, :winner_id => "true"
					}

			
		end

		describe "if successful" do
			

			it 'should create a new match' do
				lambda do
					post :create, :match => @attr
				end.should change(Match, :count).by(1)
			end

			it "should set the correct winner id" do
				post :create, :match => @attr
				assigns(:match).winner.should == @winner
			end

			it "should redirect to the index of matches" do
				post :create, :match => @attr
				response.should redirect_to matches_path

			end

		end

		describe "if failed" do

			it "should render the new template" do
				post :create, :match => @attr.merge(:player1_id => '')
				response.should render_template('new')
			end

		end

	end

	describe "DELETE 'delete'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end
 
		describe "if successful" do
			before(:each) do
				@match = FactoryGirl.create(:match, :player1_id => @user.id)
			end

			it 'should destroy the match' do
				lambda do
					delete :destroy, :id => @match.id
				end.should change(Match, :count).by(-1)


			end

		end

		describe 'if failed' do
			before(:each) do
				@other = FactoryGirl.create(:user)
				@match = FactoryGirl.create(:match, :player1_id => @other.id)
			end
			

			it 'should fail if the match does not include the logged in user' do
				lambda do
					delete :destroy, :id => @match.id
				end.should_not change(Match, :count)

			end

		end

		describe "redirection" do
			before(:each) do
				@match = FactoryGirl.create(:match, :player1_id => @user.id)
			end

			it "should redirect to the index page" do
				delete :destroy, :id => @match.id
				response.should redirect_to matches_path

			end

		end

	end

	describe "PUT 'update'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			
		end

		describe "if successful" do
			before(:each) do
				@match = FactoryGirl.create(:match, :player2_id => @user.id)
				@attr = {:player2_confirm => true}
			end

			it "should update the match attribute" do
				put :update, :id => @match.id, :match => @attr
				Match.find(@match.id).player2_confirm.should == true

			end

			it "should also make the match confirmed if the match confirmation is true across all players" do
				put :update, :id => @match.id, :match => @attr
				Match.find(@match.id).confirmed.should == true
			end

		end

		describe "failure" do
			before(:each) do
				@match = FactoryGirl.create(:match)
				@attr = {:player2_confirm => true}
			end

			it "should not allow confirmation except by current user" do
				put :update, :id => @match.id, :match => @attr
				Match.find(@match.id).player2_confirm.should == false

			end

		end

		describe "redirection" do
			before(:each) do
				@match = FactoryGirl.create(:match, :player2_id => @user.id)
				@attr = {:player2_confirm => true}
			end

			it 'should redirect to the index page' do
				put :update, :id => @match.id, :match => @attr
				response.should redirect_to matches_path
			end

		end

	end

end
