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

class Match < ActiveRecord::Base
  include ActiveModel::Validations
  
  attr_accessible :confirmed, :player1, :player1_confirm, :player1_score, :player2, :player2_confirm, :player2_score

  validates :player1, :presence => true
  validates :player2, :presence => true
  validates :player1_score, :presence => true
  validates :player2_score, :presence => true
  validates_with ValidScore, :unless => lambda{|obj| obj.player1_score.blank? || obj.player2_score.blank?}
  
  before_save :check_player_confirmation


  private
  
  def check_player_confirmation
  	self.confirmed = true if (self.player1_confirm? && self.player2_confirm?)
  end

 end
