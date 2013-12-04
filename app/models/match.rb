# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  player1_id      :integer
#  player2_id      :integer
#  winner_id       :integer
#  play_date       :date
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

  default_scope order('confirmed')
  serialize :player1_score
  serialize :player2_score

  attr_accessible :confirmed, :player1_id, :player1_confirm, :player1_score,
    :player2_id, :player2_confirm, :player2_score, :play_date,
    :winner_id

  validates :player1_id, :presence => true
  validates :player2_id, :presence => true
  validates :winner_id, :presence => true
  validates :play_date, :presence => true

  validates_with ValidScore, :unless => lambda{|obj| obj.player1_score.blank? || obj.player2_score.blank?}

  #after_validation :set_winner
  after_validation :set_player1_as_confirmed, :on => :create
  before_save :check_player_confirmation
  after_create :notify_by_email

  belongs_to :player1, :foreign_key => "player1_id", :class_name => "User"
  belongs_to :player2, :foreign_key => "player2_id", :class_name => "User"
  belongs_to :winner, :foreign_key => "winner_id", :class_name => "User"



  def players
    [self.player1, self.player2]
  end

  def opponent(opponent)
    [self.player1, self.player2].reject{|player| player == opponent}.first
  end

  def notify_by_email
    MatchMailer.match_notify(self).deliver if self.player2.match_notify_email
  end



  private

  def set_player1_as_confirmed
    self.player1_confirm = true
  end

  def check_player_confirmation
    self.confirmed = true if (self.player1_confirm? && self.player2_confirm?)
  end

  def set_winner
    if self.errors.empty?
      player1_score.sum > player2_score.sum ? self.winner_id = self.player1_id : self.winner_id = self.player2_id
    end
  end



end
