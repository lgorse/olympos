require 'spec_helper'

describe InvitationsController do

	describe "GET 'show'" do
		before(:each) do
			@invitation = FactoryGirl.create(:email_invitation, :clicked => false)
		end

		it "should redirect to the root page" do
			get :show, :id => @invitation.id, :email => @invitation.email
			response.should redirect_to root_path
		end

		describe "if the invitation matches the email origin" do

			it "should update the invitation as clicked" do	
				get :show, :id => @invitation.id, :email => @invitation.email
				Invitation.find(@invitation.id).clicked.should == true
			end


		end

		describe "if the invitation doesn't match" do
			before(:each) do
				@user = FactoryGirl.create(:user)

			end

			it "should not update the invitation as clicked" do
				get :show, :id => @invitation.id, :email => @user.email
				Invitation.find(@invitation.id).clicked.should == false

			end

		end

	end

	describe 'POST "create"' do
		before(:each) do
				@user = FactoryGirl.create(:user)
				@email = "testrandom@test.test"
				@attr = {:inviter_id => @user.id, :email => @email, :invite_method => EMAIL}
			end

		describe "if successful" do
			

			it "should create a new invitation" do
				lambda do
					post :create, :invitation => @attr
				end.should change(Invitation, :count).by(1)

			end

			it "should send an e-mail" do
				lambda do
					post :create, :invitation => @attr
				end.should change(ActionMailer::Base.deliveries, :count).by(1)
			end

			it "should render the new page" do
				post :create, :invitation => @attr.merge(:email => '')
				response.should render_template('new')
			end

		end

		describe "if failed" do
			

			it "should not create a new invitation" do
				lambda do
					post :create, :invitation => @attr.merge(:email => '')
				end.should_not change(Invitation, :count).by(1)


			end

			it 'should render the new page' do
				post :create, :invitation => @attr.merge(:email => '')
				response.should render_template('new')

			end

		end

	end

end
