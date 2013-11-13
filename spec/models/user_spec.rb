# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  firstname            :string(255)
#  lastname             :string(255)
#  password_digest      :string(255)
#  fb_id                :integer
#  birthdate            :date
#  zip                  :integer
#  lat                  :float
#  long                 :float
#  fb_pic_small         :string(255)
#  fb_pic_large         :string(255)
#  gender               :integer
#  first_rating         :integer
#  has_played           :boolean          default(FALSE)
#  available_times      :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :string(255)
#  signup_method        :integer
#  fb_pic_square        :string(255)
#  photo_file_name      :string(255)
#  photo_content_type   :string(255)
#  photo_file_size      :integer
#  photo_updated_at     :datetime
#  fullname             :string(255)
#  friend_request_email :boolean          default(TRUE)
#

require 'spec_helper'

describe User do

	describe "validations" do
		before(:each) do
			@attr = {:firstname => "test", :lastname => "tester",
				:password => "gobbldygook", 
				:birthdate => Date.strptime("8/24/70", '%m/%d/%Y'),
				:email => "test@tester.com", :gender => MALE}

			end

			describe "first and last name" do
				it "should require a first name" do
					@user = User.new(@attr.merge(:firstname => ""))
					@user.should_not be_valid

				end

				it "should require a last name"  do
					@user = User.new(@attr.merge(:lastname => ""))
					@user.should_not be_valid
				end

				it 'should create a full name from first and last' do
					@user = User.new(@attr)
					@user.save
					@user.fullname.should == "#{@user.firstname} #{@user.lastname}"

				end

			end

			describe "birthdate" do
				it "should be required" do
					@user = User.new(@attr.merge(:birthdate => ""))
					@user.should_not be_valid
				end

				it "should not belong to someone below 13" do
					@user = User.new(@attr.merge(:birthdate => Date.strptime("10/24/2010", '%m/%d/%Y')))
					@user.should_not be_valid
				end

			end

			describe "email" do

				it "should be required" do
					@user = User.new(@attr.merge(:email => ""))
					@user.should_not be_valid

				end

				it "should be well-formed" do
					bad_emails = ['test', 'test.com', 'test@']
					bad_emails.each do |email|
						user = User.new(@attr.merge(:email => email))
						user.should_not be_valid
					end
				end

				it "should be unique" do
					user1 = User.create(@attr)
					user2 = User.new(@attr)
					user2.should_not be_valid
				end

				it "should not be case-sensitive" do
					user1 = User.create(@attr)
					user2 = User.create(@attr.merge(:email => user1.email.upcase))
					user2.should_not be_valid
				end

				it "should downcase before validation" do
					email = @attr[:email].upcase
					@user = User.create(@attr.merge(:email => email))
					@user.email.should == email.downcase
				end

			end

			describe "password" do
				# it "should be required" do
				# 	@user = User.new(@attr.merge(:password_digest => ""))
				# 	@user.should_not be_valid
				# end

				it "should be at least 6 characters long" do
					@user = User.new(@attr.merge(:password => "super"))
					@user.should_not be_valid
				end
			end

			describe "gender" do

				it "should be required" do
					@user = User.new(@attr.merge(:gender => ''))
					@user.should_not be_valid

				end

			end


		end

		describe "attributes" do
			before(:each) do
				@user = FactoryGirl.create(:user)
			end

			describe "friend request email" do

			it 'should have as attribute' do
				@user.should respond_to(:friend_request_email)
			end

			it 'should be true by default' do
				@user.friend_request_email. should == true

			end

		end


		end

		describe "associations" do
			before(:each) do
				@user = FactoryGirl.create(:user)
			end



			describe "invitations" do

				it "should respond to invitations attribute" do
					@user.should respond_to(:invitations)
				end



				describe "invitees" do

					it "should respond to invitees attributes" do
						@user.should respond_to(:invitees)
					end

					it "should include a user the User has invited" do
						pending "need to think about invitee method"
					end

				end

				describe "inviters" do

					it "should respond to inviters attribute" do
						@user.should respond_to(:inviters)
					end

					it "should include the user who has invited the User" do
						pending "need to think about invitee method"
					end

				end

			end

			describe "friendships" do

				

				it "should respond to a friendships method" do
					@user.should respond_to(:friendships)
				end

				it 'should respond to a frienders method' do
					@user.should respond_to(:frienders)

				end

				it "should respond to a friendees method" do
					@user.should respond_to(:friendees)
				end

				describe "friend method" do
					before(:each) do
						@user2 = FactoryGirl.create(:user)
					end

					it "should respond to a friend method" do
						@user.should respond_to(:friend)

					end

					it "should create a new friendship" do
						lambda do
							@user.friend(@user2)
						end.should change(Friendship, :count).by(1)

					end

				end

				describe "accept method" do
					before(:each) do
						@user2 = FactoryGirl.create(:user)
						@friendship = Friendship.create(:friender_id => @user.id, :friended_id => @user2.id)
					end

					it 'should have an accept method' do
						@user.should respond_to(:accept)

					end

					it 'should create the reverse relationship' do
						@user2.accept(@user)
						Friendship.find_by_friender_id_and_friended_id(@user.id, @user2.id).mutual?.should == true
					end

				end

				describe "unfriend method" do
					before(:each) do
						@user2 = FactoryGirl.create(:user)
						@friendship = Friendship.create(:friender_id => @user.id, :friended_id => @user2.id)
					end

					it "should respond to a friend method" do
						@user.should respond_to(:unfriend)

					end

					it "should destroy the friendship" do
						@user.unfriend(@user2)
						@user.friendships.where(:friended_id => @user2.id).should be_blank
					end

					it "should destroy the reverse friendship if mutual" do
						@user2.accept(@user)
						@user.unfriend(@user2)
						@user2.friendships.where(:friender_id => @user2.id).should be_blank

					end

				end

				describe "friend? method" do
					before(:each) do
						@user2 = FactoryGirl.create(:user)
					end

					it "should respond to a friend? method" do
						@user.should respond_to(:friend?)

					end

					it "should return false if the user is not friends" do
						@user.friend?(@user2).should == false

					end

					it 'should return false if the user has not accepted' do
						@user.friend(@user2)
						@user.friend?(@user2).should == false

					end

					it "should return true if the friendship is mutual" do
						@user.friend(@user2)
						@user2.accept(@user)
						@user.friend?(@user2).should == true

					end

				end

				describe 'friendship' do
					before(:each) do
						@friend = FactoryGirl.create(:user)
						@friendship = @user.friend(@friend)
					end

					it "should have a friendship method" do
						@user.should respond_to(:friendship)
					end

					it "should return the friendship between friender and friendee" do
						@user.friendship(@friend).should == @friendship

					end

				end

				describe 'friends' do
					before(:each) do
						@friend = FactoryGirl.create(:user)
					end



					it "should respond to a friends method" do
						@user.should respond_to(:friends)

					end

					it "should return users who have responded to the request" do
						@user.friend(@friend)
						@friend.accept(@user)
						@user.friends.should include(@friend)
					end

					it "should not return users who have not responded to the request" do
						@user.friend(@friend)
						@user.friends.should_not include(@friend)

					end

				end

				describe "requested_friends" do
					before(:each) do
						@friend = FactoryGirl.create(:user)
					end

					it 'should respond to a requested_friends method' do
						@user.should respond_to(:friend_requests)

					end

					it "should returned friends who have been requested but not confirmed" do
						@user.friend(@friend)
						@user.friend_requests.should include(@friend)
					end

					it "should not return friends who have not confirmed request" do
						@user.friend(@friend)
						@friend.accept(@user)
						@user.friend_requests.should_not include(@friend)
					end

					it "should not return users who have not been contacted" do
						@user.friend_requests.should_not include(@friend)
					end

				end

				describe "friend_requests" do
					before(:each) do
						@friend = FactoryGirl.create(:user)
						@user.friend(@friend)
					end

					it "should respond to a friends_pending method" do
						@friend.should respond_to(:friends_pending)
					end

					it "should return friends who have requested but are not accepted" do
						@friend.friends_pending.should include(@user)

					end

					it "should not return friends whose friendship is not accepted" do
						@friend.accept(@user)
						@friend.friends_pending.should_not include(@user)
					end

				end


			end

		end

		describe "methods" do

			describe 'invite' do
				before(:each) do
					@user = FactoryGirl.create(:user)
				end

				
				it 'should respond to the invite method' do
					@user.should respond_to (:invite)

				end

				it "should create an invitation" do
					email = "test@new.testaroo"
					lambda do
						@user.invite(email, EMAIL)
					end.should change(Invitation, :count).by(1)

				end

			end

		end
	end

