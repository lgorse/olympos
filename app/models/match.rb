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
  attr_accessible :confirmed, :player1, :player1_confirm, :player1_score, :player2, :player2_confirm, :player2_score

  validates :player1, :presence => true
  validates :player2, :presence => true
  validates :player1_score, :presence => true
  validates :player2_score, :presence => true
  validate :validate_player_scores, :unless => lambda{|obj| obj.player1_score.blank? || obj.player2_score.blank?}
  
  before_save :check_player_confirmation


  private
  
  def check_player_confirmation
  	self.confirmed = true if (self.player1_confirm? && self.player2_confirm?)
  end

 
  def validate_player_scores
    win_count = []
    errors.add(:player1_score, "must have the same number of periods") unless (self.player1_score.count == self.player2_score.count)
    self.player1_score.count.times do |i|
      score1 = self.player1_score[i]
      score2 = self.player2_score[i]
      if [score1, score2].all?{|score| score.is_a? Integer}
        if [score1, score2].any?{|score| score > WINNING_SCORE}
          errors.add(:base, "must have a 2-point difference if scoring went beyond #{WINNING_SCORE}") if ((score1 - score2).abs != 2)
        elsif [score1, score2].all?{|score| score < WINNING_SCORE}
          errors.add(:base, "must have a winning score") 
        end
        errors.add(:base, "has already won") if [win_count.count(1), win_count.count(2)].any?{|win| win == MAX_PERIODS_TO_WIN}
        score1 > score2 ? win_count.push(1) : win_count.push(2)  
      else
        errors.add(:base, " must consist of numbers only")
      end
    end
    validate_period_structure(win_count)
  end

    def validate_period_structure(win_count)
      errors.add(:base, "must be over the regulation number of sets") if [win_count.count(1), win_count.count(2)].all?{|win| win != MAX_PERIODS_TO_WIN}
      errors.add(:base, "can only have a maximum of #{MAX_PERIODS} sets") if win_count.count > 5
    end


  end
