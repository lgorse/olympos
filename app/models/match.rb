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

class Match < ActiveRecord::Base
  include ActiveModel::Validations
  
  attr_accessible :confirmed, :player1_id, :player1_confirm, :player1_score, :player2_id, :player2_confirm, :player2_score

  validates :player1_id, :presence => true
  validates :player2_id, :presence => true
  validates :player1_score, :presence => true
  validates :player2_score, :presence => true
  validates_with ValidScore, :unless => lambda{|obj| obj.player1_score.blank? || obj.player2_score.blank?}
  
  after_validation :set_winner
  before_save :check_player_confirmation


  private
  
  def check_player_confirmation
  	self.confirmed = true if (self.player1_confirm? && self.player2_confirm?)
  end

  def set_winner
    if self.errors.empty?
    player1_score.sum > player2_score.sum ? self.winner_id = self.player1_id : self.winner_id = self.player2_id
  end
  end

 end
