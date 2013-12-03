# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  player1_id      :integer
#  player2_id      :integer
#  winner_id       :integer
#  player1_score   :text
#  player2_score   :text
#  player1_confirm :boolean          default(FALSE)
#  player2_confirm :boolean          default(FALSE)
#  confirmed       :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Match do

	describe "validations" do
		before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@attr = {:player1_id=> @user1.id, :player2_id => @user2.id,
					 :play_date => 1.day.ago.to_date, :winner_id => @user1.id}
		end

		describe "players" do

			describe "player 1" do

				it 'should be present' do
					match = Match.new(@attr.merge(:player1_id => ''))
					match.should_not be_valid
				end

			end

			describe "player 2" do

				it 'should be present' do
					match = Match.new(@attr.merge(:player2_id => ''))
					match.should_not be_valid
				end

			end

		end

		describe "play date" do

			it "should require a play date" do
				match = Match.new(@attr.merge(:play_date => ''))
				match.should_not be_valid
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

		describe "winner id" do

			it "should be required" do
				match = Match.new(@attr.merge(:winner_id => ''))
				match.should_not be_valid
			end

			it 'should be either player1 or player2' do


			end

			# it 'should show the winner if there is one' do
			# 	match = Match.create(@attr)
			# 	match.winner_id.should == @user1.id
			# end

		end

		describe "score" do
			before(:each) do
			@user1 = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user)
			@attr = {:player1_id => @user1.id, :player2_id => @user2.id, 
				:player1_score => [11, 11, 11], :player2_score => [7, 8, 4],
				:play_date => 1.day.ago.to_date, :winner_id => @user1.id}
			end

			
			describe 'score validation validation' do
				
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
					@attr = {:player1_id=> @user1.id, :player2_id => @user2.id,
							 :play_date => 1.day.ago.to_date, :winner_id => @user1.id}
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

	describe "associations" do
		before(:each) do
			@winner = FactoryGirl.create(:user)
			@loser = FactoryGirl.create(:user)
			@match = Match.create(:player1_id => @winner.id, :player2_id => @loser.id, 
								  :player1_score => [11, 11, 11], :player2_score => [4, 6, 5],
								  :play_date => 1.day.ago.to_date, :winner_id => @winner.id)

		end

		describe "players" do
			it "should have a player1 association" do
				@match.should respond_to(:player1)
			end

			it "should have a player2 association" do
				@match.should respond_to(:player2)
			end

			it "should return a player" do
				@match.player2.should == @loser
			end


		end

		describe "players" do

			it 'should have a players attribute' do
				@match.should respond_to(:players)
			end

			it 'should return the players involved' do
				@match.players.sort.should == [@winner, @loser].sort
			end
		end


		# describe "winners" do

		# 	it "should have a winner attribute" do
		# 		@match.should respond_to(:winner)
		# 	end

		# 	it "should return the winning player" do
		# 		@match.winner.should == @winner
		# 	end

		# end

		describe "opponent" do

			it "should have an opponent method" do
				@match.should respond_to(:opponent)

			end

			it "should return the other player" do
				@match.opponent(@winner).should == @loser
			end

		end

	end

	describe "scoping" do
		before(:each) do
				@last = FactoryGirl.create(:match, :play_date => 2.days.ago.to_date)
				@first = FactoryGirl.create(:match, :play_date => 1.day.ago.to_date)
			end

		it "should order by the play date in reverse" do
			Match.all.first.should == @first
			
		end

	end

end
