# == Schema Information
#
# Table name: invitations
#
#  id            :integer          not null, primary key
#  inviter_id    :integer
#  invitee_id    :integer
#  accepted      :boolean
#  message       :text
#  email         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invite_method :integer
#  fb_id         :integer
#  clicked       :boolean
#

class Invitation < ActiveRecord::Base
	

	attr_accessible :accepted, :email, :invitee_id, :inviter_id, :message, :invite_method, :fb_id, :clicked

	validates :inviter_id, :presence => true
	validates :email, :presence => true, :format => {:with => VALID_EMAIL}, :if => :requires_email?
	validates :fb_id, :presence => true, :if => :facebook_method?
	validate :invitee_has_joined, :if => :new_invitation?
	validates :invite_method, :presence => true

	belongs_to :inviter, :foreign_key => "inviter_id",  :class_name => "User"
	belongs_to :invitee, :foreign_key => "invitee_id", :class_name => "User"

	before_validation :downcase_email, :if => :requires_email?

	after_create :send_email, :if => :requires_email?


	def send_email
		EmailWorker.perform_async(INVITATION, self.id)
	end

	private

	def requires_email?
		self.invite_method == EMAIL
	end

	def facebook_method?
		self.invite_method == FACEBOOK
	end

	def new_invitation?
		self.new_record?
	end

	def downcase_email
		self.email = self.email.downcase
	end

	def invitee_has_joined
		if self.invite_method == EMAIL
			existing_user = User.find_by_email(self.email.downcase)
			if existing_user
				errors.add(:email, "has already received an invitation")
			end
		else
			existing_user = User.find_by_fb_id(self.fb_id)
			if existing_user
				errors.add(:fb_id, "has already received an invitation")
			end
		end
	end

end

