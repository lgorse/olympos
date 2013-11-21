# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city       :string(255)
#  street     :string(255)
#  zip        :integer
#  country    :string(255)
#  lat        :float
#  long       :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Club do
  
  describe "validations" do
  	before(:each) do
  		@attr = {:name => "Squash test club", :zip => 94303, :country => "US"}

  	end

  	describe 'name' do

  		it "should be required" do
  			club = Club.new(@attr.merge(:name => ''))
  			club.should_not be_valid
  		end

  	end

  	describe "zip" do

  		it "should be required" do
  			club = Club.new(@attr.merge(:zip => ''))
  			club.should_not be_valid
  		end

  		it 'should consist of integers only' do
  			club = Club.new(@attr.merge(:zip => 'soup'))
  			club.should_not be_valid

  		end

  	end

  	describe 'country' do

  		it "should be required" do
  			club = Club.new(@attr.merge(:country => ''))
  			club.should_not be_valid
  		end

  	end

  end

end
