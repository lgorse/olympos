require 'spec_helper'

describe SessionsController do
	

	describe 'GET "New"' do
		describe "if there is no session" do
			it "should be successful" do
				get :new
				response.should be_successful
			end

		end

		describe "if there is a session" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
			end

			it "should redirect the user to his home page" do
				get :new
				response.should redirect_to home_users_path
			end

		end


	end

	
	describe 'POST "Create" by email' do

		describe "if there is a user" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				@attr = {:email => @user.email, :password => @user.password}
				post :create, :session => @attr
			end

			it "should redirect to the index page" do
				response.should redirect_to search_users_path
			end

			it 'should create a session with the user id' do
				session[:user_id].should == @user.id
			end

		end

		describe 'if there is no user' do
			before(:each) do
				@user = FactoryGirl.create(:user)
				bad_email = @user.email << "n"
				@attr = {:email => bad_email, :password => @user.password}
				post :create, :session => @attr
			end

			it 'should render the new session view' do
				response.should render_template 'new'

			end

			it 'should not create a session id' do
				session[:user_id].should == nil

			end

		end

		describe "if there is a redirect url" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				@attr = {:email => @user.email, :password => @user.password}
				post :create, :session => @attr, :redirect_url => user_path(@user)
			end

			it "should redirect to the redireect url" do
				response.should redirect_to user_path(@user)

			end

		end

	end

	describe "DELETE 'Destroy'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			delete :destroy
		end

		it "should redirect to the root path" do
			response.should redirect_to root_path

		end

		it "should destroy the session" do
			session[:user_id].should be_nil
		end

		it "should destroy all cookies" do
			cookies.each {|crunchy| crunchy.should be_nil}

		end

	end
end
