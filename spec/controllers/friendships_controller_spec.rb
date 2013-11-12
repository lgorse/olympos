require 'spec_helper'

describe FriendshipsController do

	describe "post 'create'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@friend = FactoryGirl.create(:user)
			@attr = {:friender_id => @user.id, :friended_id => @friend.id}
		end

		describe "authenticate" do

			describe "if failed" do


				it "should redirect to the root path if not authenticated" do
					post :create, :friendship => @attr
					response.should redirect_to root_path
				end

				it "should not create a new friendship" do
					lambda do
						post :create, :friendship => @attr
					end.should_not change(Friendship, :count)

				end

			end

			describe "if successful" do
				before(:each) do
					test_sign_in(@user)
				end

				it "should be successful" do
					post :create, :friendship => @attr
					response.should be_successful
				end

			end

		end

		describe "create friendship" do
			before(:each) do
				test_sign_in(@user)
			end

			

			it "should create a new friendship" do
				lambda do
					post :create, :friendship => @attr
				end.should change(Friendship, :count).by(1)
			end

		end	

	end

	describe "DELETE 'destroy'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@friend = FactoryGirl.create(:user)
			@user.friend(@friend)
			@friendship = Friendship.find_by_friender_id_and_friended_id(@user.id, @friend.id)
		end



		describe "if one-sided friendship"  do

			it 'should destroy the friendship' do
				lambda do
					delete :destroy, :id => @friendship.id
				end.should change(Friendship, :count).by(-1)

			end

		end

	end

	describe "GET 'friendships" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@friend = FactoryGirl.create(:user)
			@user.friend(@friend)
			@friend.accept(@user)
		end

		it "should show the user's friendships" do
			get :friendships, :user_id => @user.id
			assigns(:friendships).should == @user.friendships

		end

	end

	describe "GET 'requests'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@friend = FactoryGirl.create(:user)
			@user.friend(@friend)
		end

		it "should show the user's friend requests" do
			get :requests, :user_id => @user.id
			assigns(:friend_requests).should == @user.friend_requests

		end


	end

	describe "GET 'pending'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@friend = FactoryGirl.create(:user)
			@friend.friend(@user)
		end

		it "should show the user's friend requests" do
			get :pending, :user_id => @user.id
			assigns(:friends_pending).should == @user.friends_pending

		end

	end

end
