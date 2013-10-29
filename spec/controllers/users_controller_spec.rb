require 'spec_helper'

describe UsersController do

	describe 'GET "new"' do

	end

	describe 'POST "create"' do
		before(:each) do
			@attr = {:firstname => "test", :lastname => "tester", 
				:email => "test@test.com", :password => "gobbledygook",
				:birthdate => 14.years.ago.to_date}
			end

			describe 'if successful' do


				it "should create a new user" do
					lambda do
						post :create, :user => @attr
					end.should change(User, :count).by(1)
				end

				it "should redirect to the index page" do
					post :create, :user => @attr
					response.should redirect_to details_user_path(assigns(:user))
				end

				it "should create a session" do
					post :create, :user => @attr
					session[:user_id].should == assigns(:user).id
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

				describe "if from the detail form" do

					it "should redirect to the recommendation page" do
						@origin = true
						put :update, :id => @user.id, :user => @attr, :detail_form => @origin
						response.should redirect_to users_path
					end
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

		describe "GET 'index'" do

			describe "authentication" do
				before(:each) do
					@user = FactoryGirl.create(:user)

				end

				describe "if successful" do

					it 'should be successful' do
						test_sign_in(@user)
						get :index
						response.should be_successful
					end

				end

				describe 'if failed' do

					it "should redirect to root" do
						get :index
						response.should redirect_to root_path

					end

				end

			end

		end

	end
