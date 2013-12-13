require "spec_helper"

describe InviteMailer do
	describe "e-mail" do

		describe "asynchronously" do
			before(:each) do
				@invitation = FactoryGirl.create(:email_invitation)
			end

			it "should send the message asynchronously" do
				lambda do
					EmailWorker.new.perform(INVITATION, @invitation.id)
				end.should change(ActionMailer::Base.deliveries, :count).by(1)

			end

		end
		
		describe "delivery" do
			before(:each) do
				@invitation = FactoryGirl.create(:email_invitation)
				@mailer = InviteMailer.invite_email(@invitation)
			end

			it "should deliver the e-mail" do
				lambda do
					@mailer.deliver
				end.should change(ActionMailer::Base.deliveries, :count).by(1)
			end

			it "should deliver the e-mail to the recipient" do
				@mailer.deliver
				ActionMailer::Base.deliveries.last.to.should ==  [@invitation.email]
			end

		end

		describe "format" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				@invitation = FactoryGirl.create(:email_invitation)
				@mailer = InviteMailer.invite_email(@invitation)
			end

			it "subject should have sender name" do
				@mailer.subject.should include(@user.firstname)
			end

			it "should feature the name of the app" do
				@mailer.body.should have_content(APP_NAME)

			end

			it "should have a login button" do
				@mailer.body.should have_link("Join now")

			end

		end

		describe "e-mail reception" do

		end
	end

end
