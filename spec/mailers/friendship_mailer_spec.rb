require "spec_helper"

describe FriendshipMailer do
	describe "delivery" do
		before(:each) do
			@friendship = FactoryGirl.create(:friendship)
			@mailer = FriendshipMailer.friend_request(@friendship)
		end

		it "should deliver the e-mail" do
			lambda do
				@mailer.deliver
			end.should change(ActionMailer::Base.deliveries, :count).by(1)

		end

		it "should deliver the e-mail to the recipient" do
			@mailer.deliver
			ActionMailer::Base.deliveries.last.to.should == [@friendship.friended.email]

		end

	end

	describe "format" do
		before(:each) do
				@friendship = FactoryGirl.create(:friendship)
				@mailer = FriendshipMailer.friend_request(@friendship)
				
			end

			it 'subject should have sender name' do
				@mailer.subject.should include(@friendship.friender.firstname)

			end

			it "should feature the name of the app" do
				@mailer.body.should have_content(APP_NAME)

			end

			it 'should have a link back to the friender profile' do
				@mailer.body.should have_link("Visit #{@friendship.friender.firstname}\'s profile", user_path(@friendship.friender, :redirect_url => user_path(@friendship.friender)))

			end

	end
end
