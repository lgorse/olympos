# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  club_id    :integer
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  attr_accessible :club_id, :rating, :user_id

  validates :club_id, :presence => true
  validates :user_id, :presence => true
end
