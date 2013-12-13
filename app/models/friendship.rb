# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  friender_id :integer
#  friended_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  confirmed   :boolean          default(FALSE)
#

class Friendship < ActiveRecord::Base
  

  attr_accessible :friended_id, :friender_id, :confirmed

  validates :friender_id, :presence => true
  validates :friended_id, :presence => true

  validates_uniqueness_of :friender_id, :scope => :friended_id

  belongs_to :friender, :foreign_key => "friender_id", :class_name => "User"
  belongs_to :friended, :foreign_key => "friended_id", :class_name => "User"

  before_create :confirm_if_reverse_exists

  after_create :email_request

  scope :mutual, -> {where(confirmed: true)}
  scope :not_accepted, -> {where(confirmed: false)}


  def mutual?
  	self.confirmed
  end

  def make_mutual
  	reverse_friendship = Friendship.create(:friender_id => self.friended_id, :friended_id => self.friender_id, :confirmed => true)
    self.update_attributes(:confirmed => true)
    reverse_friendship.update_attributes(:confirmed => true)
  end

  def reverse
  	Friendship.find_by_friender_id_and_friended_id(self.friended_id, self.friender_id)
  end

  
  def email_request
    EmailWorker.perform_async(FRIENDSHIP, self.id) if self.friended.friend_request_email
  end

  private
  def confirm_if_reverse_exists
    if reverse_friendship = self.reverse
      self.confirmed = true
      reverse_friendship.confirmed = true
      reverse_friendship.save
    end

  end

end
