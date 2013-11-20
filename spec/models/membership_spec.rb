# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  club_id    :integer
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Membership do

	describe 'validations' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@club = FactoryGirl.create(:club)
			@attr = {:user_id => @user.id, :club_id => @club.id}

		end

		it "should require a user" do
			membership = Membership.new(@attr.merge(:user_id => ''))
			membership.should_not be_valid
		end

		it "should require a club" do
			membership = Membership.new(@attr.merge(:club_id => ''))
			membership.should_not be_valid
		end

	end

	describe "associations" do

		it 'should have a user' do

		end

		it 'should have a club' do

		end

		it "should be destroyed with the user" do

		end

		it "should be destroyed with the club" do

		end

	end
end
