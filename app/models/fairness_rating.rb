# == Schema Information
#
# Table name: fairness_ratings
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  rater_id   :integer
#  rated_id   :integer
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FairnessRating < ActiveRecord::Base
  attr_accessible :match_id, :rated_id, :rater_id, :rating

  validates :match_id, :presence => true
  validates :rated_id, :presence => true
  validates :rater_id, :presence => true
  validates :rating, :presence => true, :numericality => {:less_than_or_equal_to => 5, :greater_than => 0}
  validates_uniqueness_of :match_id, :scope => [:rater_id, :rated_id]

  belongs_to :match
  belongs_to :rater, :class_name => "User"
  belongs_to :rated, :class_name => "User"

  after_validation :validate_match_players

  def raters
  	[self.rater, self.rated]
  end

  private
  def validate_match_players
    return false unless self.errors.empty?
      if self.match.players.sort != self.raters.sort
        errors[:base] << "Raters must be match players"
      end
  end

end
