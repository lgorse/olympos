require 'spec_helper'

describe UsersController do
	render_views

	describe 'GET "new"' do

	end

	describe 'POST "create" BY EMAIL' do
		before(:each) do
			@attr = {:firstname => "test", :lastname => "tester", 
				:email => "test@test.com", :password => "gobbledygook",
				:birthdate => 14.years.ago.to_date, :gender => MALE}
			end

			describe 'if successful' do


				it "should create a new user" do
					lambda do
						post :create, :user => @attr
					end.should change(User, :count).by(1)
				end

				it "should redirect to the details page" do
					post :create, :user => @attr
					response.should redirect_to details_user_path(assigns(:current_user))
				end

				it "should create a session" do
					post :create, :user => @attr
					session[:user_id].should == assigns(:current_user).id
				end
			end

			describe 'if failed' do

				it "should render a new page" do
					post :create, :user => @attr.merge(:firstname => '')
					response.should render_template('new')

				end

				it "should show the error" do
					post :create, :user => @attr.merge(:firstname => '')

				end

				it "should not create a new user" do
					lambda do
						post :create, :user => @attr.merge(:firstname => '')
					end.should_not change(User, :count)

				end

			end


		end


		describe 'PUT "Update"' do
			before(:each) do
				@user = FactoryGirl.create(:user)
			end

			describe 'if successful' do
				before(:each) do
					@attr = {:zip => 94305}
				end

				it "should update the user\'s attributes" do
					put :update, :id => @user.id, :user => @attr
					User.find(@user).zip.should == @attr[:zip]
				end


				it "should redirect to the address in the redirect_url" do
					
					put :update, :id => @user.id, :user => @attr, :redirect_url => details_user_path(@user)
					response.should redirect_to details_user_path
				end
				



			end

			describe 'if failed' do


			end

		end

		describe "GET 'details'" do

			describe "authentication" do
				before(:each) do
					@user = FactoryGirl.create(:user)
				end

				describe "if successful" do

					it 'should be successful' do
						test_sign_in(@user)
						get :details, :id => @user.id
						response.should be_successful
					end

				end

				describe 'if failed' do

					it "should redirect to root" do
						get :details, :id => @user.id
						response.should redirect_to root_path

					end

				end

			end


		end

		describe "GET 'home'" do

			describe "authentication" do
				before(:each) do
					@user = FactoryGirl.create(:user)

				end

				describe "if successful" do

					it 'should be successful' do
						test_sign_in(@user)
						get :home, :id => @user
						response.should be_successful
					end

				end

				describe 'if failed' do

					it "should redirect to root" do
						get :home, :id => @user
						response.should redirect_to root_path

					end

				end

			end

		end

		describe "GET 'edit'" do
			

			describe "authentication" do
				before(:each) do
					@user = FactoryGirl.create(:user)
				end

				describe "if successful" do

					it 'should be successful' do
						test_sign_in(@user)
						get :edit, :id => @user
						response.should be_successful
					end

					

					
				end

				describe 'if failed' do

					it "should redirect to root" do
						get :edit, :id => @user
						response.should redirect_to root_path

					end

				end

			end

		end

		describe "DELETE 'destroy'" do
			describe "authentication" do
				before(:each) do
					@user = FactoryGirl.create(:user)
				end

				describe "if successful" do

					it 'should destroy the user' do
						test_sign_in(@user)
						lambda do
							delete :destroy, :id => @user
						end.should change(User, :count).by(-1)
					end

					

					
				end

				describe 'if failed' do

					it "should not destroy the user" do
						lambda do
							delete :destroy, :id => @user
						end.should_not change(User, :count)
					end

				end

			end

			describe 'redirect' do
				before(:each) do
					@user = FactoryGirl.create(:user)
					test_sign_in(@user)
				end

				it 'should redirect to the root path' do
					delete :destroy, :id => @user.id
					response.should redirect_to root_path

				end

			end

		end

		describe "GET 'map'" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				3.times {|i| FactoryGirl.create(:user, :zip => "9430#{i}")}
				test_sign_in(@user)
			end

			describe "general function"  do

				it "should not include the user" do
					get :map, :zip => @user.zip, :user => @user.attributes, :distance => 10
					assigns(:nearby_users).should_not include(@user)

				end

			end

			describe "if there are all the params" do

				it "should return the search results according to the params" do
					get :map, :zip => 94305, :user => @user.attributes, :distance => 5
					assigns(:nearby_users).pluck(:id).should == User.near(Geocoder.coordinates("#{94305} #{@user.country}"), 5).without_user(@user).pluck(:id)
				end

			end

			describe "if there are not all the params" do

				it "should return the search based on default values" do
					get :map
					assigns(:nearby_users).pluck(:id).should == @user.nearbys(10).pluck(:id)

				end

			end

			describe "if there are no lats or longs" do
				before(:each) do
					@user.update_attributes(:lat => '', :long => '')
				end

				it "should return values based on the request params" do

					get :map
					assigns(:nearby_users).pluck(:id).should == User.near([request.location.latitude, request.location.longitude], 20).without_user(@current_user).pluck(:id)
				end

			end

		end


	end
