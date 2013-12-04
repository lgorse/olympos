# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  friender_id :integer
#  friended_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  confirmed   :boolean          default(FALSE)
#

require 'spec_helper'

describe Friendship do

	describe "validations" do
		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@attr = {:friender_id => @user1.id, :friended_id => @user2.id}

		end

		it "should have a friender id" do
			friendship = Friendship.new(@attr.merge(:friender_id => ''))
			friendship.should_not be_valid

		end

		it "should have a friended id" do
			friendship = Friendship.new(@attr.merge(:friended_id => ''))
			friendship.should_not be_valid

		end

		it "should be unique" do
			friendship1 = Friendship.create(@attr)
			friendship2 = Friendship.new(@attr)
			friendship2.should_not be_valid
		end

	end

	describe "dependencies" do
		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@friendship = Friendship.create(:friender_id => @user1.id, :friended_id => @user2.id)
		end

		it "should have a friender" do
			@friendship.should respond_to(:friender)

		end

		it "should have a friended" do
			@friendship.should respond_to(:friended)

		end

		it "should be destroyed with the user" do
			@user1.destroy
			Friendship.find_by_friender_id(@user1.id).should be_blank
		end

	end

	describe "attributes" do

		describe "check if a method is mutual" do
			before(:each) do
				@user1 = FactoryGirl.create(:user)
				@user2 = FactoryGirl.create(:user)
				@friendship = Friendship.create(:friender_id => @user1.id, :friended_id => @user2.id)
			end


			it "should respond to a mutual? method" do
				@friendship.should respond_to(:mutual?)
			end

			it "should be false if the friendship is not mutual" do
				Friendship.find_by_friender_id_and_friended_id(@user1.id, @user2.id).mutual?.should == false

			end

			it "should be true if the friendship is mutual" do
				@friendship.make_mutual
				Friendship.find_by_friender_id_and_friended_id(@user1.id, @user2.id).mutual?.should == true
			end


		end

		describe "make a friendship mutual" do
			before(:each) do
				@user1 = FactoryGirl.create(:user)
				@user2 = FactoryGirl.create(:user)
				@friendship = Friendship.create(:friender_id => @user1.id, :friended_id => @user2.id)
			end

			it "should respond to a make_mutual method" do
				@friendship.should respond_to(:make_mutual)

			end

			it "should create a reverse friendship" do
				@friendship.make_mutual
				Friendship.find_by_friender_id_and_friended_id(@user1.id, @user2.id).mutual?.should == true
			end

		end

		describe "reverse friendship" do
			before(:each) do
				@user1 = FactoryGirl.create(:user)
				@user2 = FactoryGirl.create(:user)
				@friendship = Friendship.create(:friender_id => @user1.id, :friended_id => @user2.id)
			end

			it "should respond to a reverse friendship" do
				@friendship.should respond_to(:reverse)

			end

			it "should give the reverse friendship" do
				@user2.accept(@friendship)
				@friendship.reverse.should == Friendship.find_by_friender_id_and_friended_id(@user2.id, @user1.id)
			end

		end


	end

	describe "reverse_friendships" do
		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@friendship = Friendship.create(:friender_id => @user1.id, :friended_id => @user2.id)
		end

		it "should be destroyed with the user" do
			@user2.destroy
			Friendship.find_by_friended_id(@user2.id).should be_blank

		end

	end

	describe "if there is a friendship and reverse_friendship with the same users" do
		before(:each) do
			@friender = FactoryGirl.create(:user)
			@friended = FactoryGirl.create(:user)
			@friender.friend(@friended)
			
		end

		it "should automatically make the friendship mutual if there is a reverse friendship" do
			@friended.friend(@friender)
			friendship = Friendship.find_by_friender_id_and_friended_id(@friender.id, @friended.id)
			reverse_friendship = friendship.reverse			
			friendship.confirmed?.should == true
			reverse_friendship.confirmed?.should == true
		end

	end

	

end
