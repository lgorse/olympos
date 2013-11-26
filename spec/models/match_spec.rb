# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  player1         :integer
#  player2         :integer
#  player1_score   :text
#  player2_score   :text
#  player1_confirm :boolean
#  player2_confirm :boolean
#  confirmed       :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Match do

	describe "validations" do
		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@attr = {:player1=> @user1.id, :player2 => @user2.id, 
				:player1_score => [11, 11, 11], :player2_score => [7, 8, 4]}
		end

		describe "players" do

			describe "player 1" do

				it 'should be present' do
					match = Match.new(@attr.merge(:player1 => ''))
					match.should_not be_valid
				end

			end

			describe "player 2" do

				it 'should be present' do
					match = Match.new(@attr.merge(:player2 => ''))
					match.should_not be_valid
				end

			end

		end

		describe "player confirmation" do
			describe 'player1_confirm' do

				it 'should default to false' do
					match = FactoryGirl.build(:match)
					match.player1_confirm.should == false
				end

			end

			describe 'player2_confirm' do

				it 'should default to false' do
					match = FactoryGirl.build(:match)
					match.player2_confirm.should == false
				end

			end

		end

		describe "confirmed" do
			it 'should default to false' do
				match = FactoryGirl.build(:match)
				match.confirmed.should == false

			end

			it 'should go to true if both players have confirmed' do
				match =  Match.create(@attr.merge(:player1_confirm => true, :player2_confirm => true))
				match.errors.full_messages.each {|msg| print msg}
				match.confirmed.should== true
			end

		end

		describe "score" do
			before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@attr = {:player1=> @user1.id, :player2 => @user2.id, 
				:player1_score => [11, 11, 11], :player2_score => [7, 8, 4]}
			end

			describe "presence validation" do

				it 'should require a player1 score' do
					match = Match.new(@attr.merge(:player1_score => ''))
					match.should_not be_valid
				end

				it 'should require a player2 score' do
					match = Match.new(@attr.merge(:player2_score => ''))
					match.should_not be_valid
				end


			end

			describe 'period validation' do
				before(:each) do
					@user1 = FactoryGirl.create(:user)
					@user2 = FactoryGirl.create(:user)
					@attr = {:player1=> @user1.id, :player2 => @user2.id, 
						:player1_score => [11, 11, 11], :player2_score => [7, 8, 4]}
				end

				it 'should have the same length' do
					match = Match.new(@attr.merge(:player1_score => [11, 11]))
					match.should_not be_valid

				end

				it 'should require that the scores be numbers' do
					match = Match.new(@attr.merge(:player1_score => ["hello", 2, 3]))
					match.should_not be_valid
				end

				it 'should check if each period has reached the cutoff score' do
					match = Match.new(@attr.merge(:player1_score => [7, 8, 1],
												  :player2_score => [6, 7, 11]))
					match.should_not be_valid
				end

				it 'should validate each period if the period goes into overscore' do
					match = Match.new(@attr.merge(:player1_score => [11, 11, 12],
												  :player2_score => [6, 7, 11]))
					match.should_not be_valid
				end

				it 'should allow for a victor with 3 winning sets only' do
					match = Match.new(@attr.merge(:player1_score => [11, 11, 12, 11],
												  :player2_score => [6, 7, 10, 9]))
					match.should_not be_valid
				end

				it "should not allow for more sets than allowed" do
					match = Match.new(@attr.merge(:player1_score => [11, 11, 12, 8, 7, 8],
												  :player2_score => [6, 7, 10, 11, 11, 11]))
					
					match.should_not be_valid
				end

				it "should not allow playing after the player has won his minimum sets" do
					match = Match.new(@attr.merge(:player1_score => [11, 11, 12, 8],
												  :player2_score => [6, 7, 10, 11]))
					
					match.should_not be_valid
				end

			end

			describe "correct scoring" do
				before(:each) do
					@user1 = FactoryGirl.create(:user)
					@user2 = FactoryGirl.create(:user)
					@attr = {:player1=> @user1.id, :player2 => @user2.id}
				end

				it "should pass a simple 3-0 game" do
					match = Match.new(@attr.merge(:player1_score => [11, 11, 11],
												  :player2_score => [7, 8, 4]))						
					match.should be_valid
				end

				it "should pass a contested 3-1 game" do
					match = Match.new(@attr.merge(:player1_score => [11, 11, 4, 11],
												  :player2_score => [7, 8, 11, 5]))						
					match.should be_valid
				end

				it "should pass a tight per period game" do
					match = Match.new(@attr.merge(:player1_score => [14, 11, 10, 11],
												  :player2_score => [12, 8, 12, 5]))						
					match.should be_valid

				end

				it "should pass a 3-2 game" do
					match = Match.new(@attr.merge(:player1_score => [14, 11, 10, 5, 11],
												  :player2_score => [12, 8, 12, 11, 6]))						
					match.should be_valid
				end


			end



		end


	end

end
