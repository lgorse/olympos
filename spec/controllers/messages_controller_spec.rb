require 'spec_helper'

describe MessagesController do

	describe 'GET "new" (and before_filter tests)' do
		render_views
		
		describe "before_filter tests" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
			end

			describe "authentication" do
				before(:each) do
					session[:user_id] = nil
					@unsigned_user = FactoryGirl.create(:user)
				end

				it "should authenticate the user" do
					get :new
					response.should redirect_to root_path
				end

			end

			it "should get the user\'s mailbox" do
				get :new
				assigns(:mailbox).should be_present
			end

		end

		describe "successful" do
			before(:each) do
				@user =  FactoryGirl.create(:user)
				test_sign_in(@user)		
			end

			it 'should be successful' do
				get :new
				response.should be_successful

			end

			it 'should have a full_name field' do
				get :new
				response.body.should have_field(:recipient_name)

			end

			it 'should have a body field' do
				get :new
				response.body.should have_field(:message_body)
			end

		end


	end

	describe 'POST create' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@recipient = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		describe 'if successful' do
			before(:each) do
				@attr = {:recipient_id => @recipient.id, :body => "Hello test"}

			end

			describe "if single recipient" do

				it 'should create a new message' do
					lambda do
						post :create, :message => @attr
					end.should change(Message, :count).by(1)

				end

			end

			describe "if multiple recipients" do
				before(:each) do
					@other_friend = FactoryGirl.create(:user)
				end

				it "should create a message for each" do
					post :create, :message => @attr.merge(:recipient_id => "#{@recipient.id}, #{@other_friend.id}")
					Message.first.recipients.count.should == 3
				end

			end

		end

		describe 'if a conversation already exists' do
			before(:each) do
				@user.send_message(@recipient, "Hi test", "test subject") 
				@attr = {:recipient_id => @recipient.id, :body => "And another thing"}
			end

			it 'should not create a new conversation' do
				lambda do
					post :create, :message => @attr
				end.should_not change(Conversation, :count)

			end

		end



		describe 'if failed' do
			before(:each) do
				@attr = {:recipient_id => '', :body => "Ooh test"}

				it 'should render the new page' do
					post :create, :message => @attr
					response.body.should render_template('new')

				end

			end

		end

		

	end

end
