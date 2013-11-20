require 'spec_helper'

describe ClubsController do

	describe 'GET New' do

		describe 'authentication ' do

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

	end

	describe "POST 'create'" do
		before(:each) do
					@user = FactoryGirl.create(:user)
					@attr = {:name => "test", :zip => 75, :country => "US"}
				end

		describe "authentication" do
				

				describe "if successful" do

					it 'should be successful' do
						test_sign_in(@user)
						post :create, :club => @attr
						response.should be_redirect
					end

				
				end

				describe 'if failed' do

					it "should redirect to root_path" do
						post :create, :club => @attr
						response.should redirect_to root_path
					end

				end

			end

		describe "if successful" do
			before(:each) do
				test_sign_in(@user)
			end

			it "should add a new club" do
				lambda do
					post :create, :club => @attr
				end.should change(Club, :count).by(1)
			end

			it "shoud redirect back to new club page" do
				post :create,  :club => @attr
				response.should redirect_to new_club_path
		end

		end

		describe "if failed" do
			before(:each) do
				test_sign_in(@user)
			end

			it "should not add a new club" do
				lambda do
					post :create, :club => @attr.merge(:zip => '')
				end.should_not change(Club, :count)
			end

			it "should render the new view" do
				post :create, :club => @attr.merge(:zip => '')
				response.should render_template('new')

			end

		end

	end

	describe "PUT 'update'" do
		before(:each) do
					@user = FactoryGirl.create(:user)
					@attr = {:name => "test", :zip => 75, :country => "US"}
					@club = Club.create(@attr)
				end

		describe "authentication" do
				

				describe "if successful" do

					it 'should be successful' do
						test_sign_in(@user)
						put :update, :id => @club.id, :club => @attr
						response.should be_redirect
					end

				
				end

				describe 'if failed' do

					it "should redirect to root_path" do
						put :update, :id => @club.id, :club => @attr
						response.should redirect_to root_path
					end

				end

			end

		describe "if successful" do
			before(:each) do
				test_sign_in(@user)
			end

			it "should change the club attribute" do
					put :update, :id => @club.id, :club => @attr.merge(:name => "new")
					Club.find(@club.id).name.should == "new"
				
			end

			it "should redirect back to new club page" do
				put :update,  :id => @club.id, :club => @attr
				response.should redirect_to new_club_path
		end

		end

		describe "if failed" do
			before(:each) do
				test_sign_in(@user)
			end

			it "should not add a new club" do
				lambda do
					put :update, :id => @club.id, :club => @attr.merge(:zip => '')
				end.should_not change(Club, :count)
			end

			it "should render the new view" do
				put :update, :id => @club.id, :club => @attr.merge(:zip => '')
				response.should render_template('new')

			end

		end

	end


end
