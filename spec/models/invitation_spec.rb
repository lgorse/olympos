# == Schema Information
#
# Table name: invitations
#
#  id            :integer          not null, primary key
#  inviter_id    :integer
#  invitee_id    :integer
#  accepted      :boolean
#  message       :text
#  email         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invite_method :integer
#  fb_id         :integer
#  clicked       :boolean
#

require 'spec_helper'

describe Invitation do


	describe "validations" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@attr = {:inviter_id => @user.id, :email => "test@tester.test", :invite_method => EMAIL}
		end


		describe "email" do

			it "should be required if the method is email" do
				invitation = Invitation.new(@attr.merge(:email => ''))
				invitation.should_not be_valid
			end

			it "should be well-formed" do
				invitation = Invitation.new(@attr.merge(:email => ''))
				invitation.should_not be_valid
			end

			it "should be valid even absent the fb id" do
				invitation = Invitation.new(@attr.merge(:fb_id => ''))
				invitation.should be_valid
			end

			it 'should not be valid if the user has already joined' do
				user2 = FactoryGirl.create(:user, :email => @attr[:email])
				invitation = Invitation.new(@attr)
				invitation.should_not be_valid
			end

			it "should downcase before validation" do
					email = @attr[:email].upcase
					invitation = Invitation.create(@attr.merge(:email => email))
					invitation.email.should == email.downcase
				end

		end

		describe "inviter" do

			it "should be required" do
				invitation = Invitation.new(@attr.merge(:inviter_id => ''))
				invitation.should_not be_valid
			end

		end

		describe 'method' do

			it "should be required" do
				invitation = Invitation.new(@attr.merge(:invite_method => ''))
				invitation.should_not be_valid
			end

		end

		describe "facebook id" do

			it 'should be required if the method is facebook' do
				invitation = Invitation.new(@attr.merge(:invite_method => FACEBOOK, :fb_id => ''))
				invitation.should_not be_valid
			end

			it "should be valid absent email if method is facebook" do
				invitation = Invitation.new(@attr.merge(:invite_method => FACEBOOK, :fb_id => 100, :email => ''))
				invitation.should be_valid
			end

			it "should check if a user has joined" do
				@user2 = FactoryGirl.create(:user, :fb_id =>(@user.id+1))
				invitation = Invitation.new(@attr.merge(:invite_method => FACEBOOK, :fb_id => @user2.fb_id, :email => ''))
				invitation.should_not be_valid

			end

		end

	end

	describe "attributes" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@attr = {:inviter_id => @user.id, :email => "test@tester.test"}
		end

		describe "inviter" do

			it "should have an inviter attribute" do
				invitation = Invitation.create(@attr)
				invitation.should respond_to(:inviter)
			end

			it 'should be the creator of the invitation' do
				invitation = Invitation.create(@attr)
				invitation.inviter.id.should == @user.id
			end

		end

		describe "invitee" do
			it "should have an invitee attribute" do
				invitation = Invitation.create(@attr)
				invitation.should respond_to(:invitee)

			end

		end

	end

	describe "invitation message" do

		describe "by Facebook" do

			it "should not send an email" do

			end

			it "should return a status from Facebook" do
				pending "implementation of Facebook invite"

			end

		end

		describe "by email" do
			
			it "should send an email" do
				lambda do
					@invitation = FactoryGirl.create(:email_invitation)
				end.should change(EmailWorker.jobs, :size).by(1)

			end

		end

	end

end
