# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  firstname          :string(255)
#  lastname           :string(255)
#  password_digest    :string(255)
#  fb_id              :integer
#  birthdate          :date
#  zip                :integer
#  lat                :float
#  long               :float
#  fb_pic_small       :string(255)
#  fb_pic_large       :string(255)
#  gender             :integer
#  first_rating       :integer
#  has_played         :boolean          default(FALSE)
#  available_times    :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  email              :string(255)
#  signup_method      :integer
#  fb_pic_square      :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

require 'spec_helper'

describe User do

	describe "validations" do
		before(:each) do
			@attr = {:firstname => "test", :lastname => "tester",
				:password => "gobbldygook", 
				:birthdate => Date.strptime("8/24/70", '%m/%d/%Y'),
				:email => "test@tester.com"}

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

		end
	end
