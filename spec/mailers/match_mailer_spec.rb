require "spec_helper"

describe MatchMailer do
  describe "asynchronously" do

    before(:each) do
      @recipient_wants_emails = FactoryGirl.create(:user)
      @match = FactoryGirl.create(:match, :player2_id => @recipient_wants_emails.id)
    end

    it "should send an e-mail to the recipient" do
      lambda do
        EmailWorker.new.perform(MATCH, @match.id)
      end.should change(ActionMailer::Base.deliveries, :count).by(1)
    end

  end
end
