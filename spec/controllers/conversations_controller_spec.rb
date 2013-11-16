require 'spec_helper'

describe ConversationsController do

	describe 'GET show (and before_filter tests)' do
		
		describe "before_filter tests" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
				@conversation = Conversation.create(:subject => "hello there")
			end

			describe "authentication" do
				before(:each) do
					session[:user_id] = nil
					@unsigned_user = FactoryGirl.create(:user)
				end

				it "should authenticate the user" do
					get :show, :id => @conversation
					response.should redirect_to root_path
				end

			end

			it "should get the user\'s mailbox" do
				get :show, :id => @conversation
				assigns(:mailbox).should be_present
			end

		end

		describe "if successful" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
				@conversation = Conversation.create(:subject => "hello there")
			end

			it "should be successful" do
				get :show, :id => @conversation
				response.should be_successful

			end

		end

	end

	describe 'PUT "update"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@recipient = FactoryGirl.create(:user)
			@first_message = @user.send_message(@recipient, "hi bro", "hi!")
			@conversation = @first_message.conversation
			@attr = {:body => "And how this"}
		end

		describe "if successful" do

			it "should redirect back to the conversation" do
				put :update, :id => @conversation.id, :body => @attr[:body]
				response.should redirect_to @conversation

			end

			it 'should create a new message' do
				lambda do
				put :update, :id => @conversation.id, :body => @attr[:body]
				end.should change(Message, :count).by(1)
			end

		end

		describe 'if failed' do
			before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@recipient = FactoryGirl.create(:user)
			@first_message = @user.send_message(@recipient, "hi bro", "hi!")
			@conversation = @first_message.conversation
			@attr = {:body => ""}
		end

			it 'should render the show template' do
				put :update, :id => @conversation.id, :body => @attr[:body]
				response.should render_template('show')

			end

		end

	end

end
