require "spec_helper"

describe CustomMessageMailer do
	describe "Custom email worker" do
		before(:each) do
			@sender = FactoryGirl.create(:user)
			@recipient = FactoryGirl.create(:user)
			@receipt = @sender.send_message(@recipient, "Hi bro", "Someone likes you")
		end

		it "should send the email asynchronously" do
			lambda do
				MessageEmailWorker.new.perform(@receipt.id, @recipient.id)
			end.should change(ActionMailer::Base.deliveries, :count).by(1)

		end

	end
	describe "delivery" do
		before(:each) do
			@sender = FactoryGirl.create(:user)
			@recipient = FactoryGirl.create(:user)
			@receipt = @sender.send_message(@recipient, "Hi bro", "Someone likes you")
			@mailer = CustomMessageMailer.send_email(@receipt, @recipient)
		end

		it "should deliver the email" do
			lambda do
				@mailer.deliver
			end.should change(ActionMailer::Base.deliveries, :count).by(1)
		end

		it "should deliver the e-mail to the recipient" do
			@mailer.deliver
			ActionMailer::Base.deliveries.last.to.should == [@recipient.email]

		end

	end

	describe "format" do
		before(:each) do
			@sender = FactoryGirl.create(:user)
			@recipient = FactoryGirl.create(:user)
			@receipt = @sender.send_message(@recipient, "Hi bro", "Someone likes you")
			@mailer = CustomMessageMailer.send_email(@receipt, @recipient)
		end

		it 'subject should have sender name' do
			@mailer.subject.should include(@sender.firstname)
		end

		it 'should feature the name of the app' do
			@mailer.body.should have_content(APP_NAME)

		end

		it 'should have a link back to the message' do
			@mailer.body.should have_link("Respond to #{@sender.firstname}")

		end

	end
end
