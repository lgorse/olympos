# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  firstname            :string(255)
#  lastname             :string(255)
#  password_digest      :string(255)
#  fb_id                :integer
#  birthdate            :date
#  zip                  :integer
#  lat                  :float
#  long                 :float
#  fb_pic_small         :string(255)
#  fb_pic_large         :string(255)
#  gender               :integer
#  first_rating         :integer
#  has_played           :boolean          default(FALSE)
#  available_times      :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :string(255)
#  signup_method        :integer
#  fb_pic_square        :string(255)
#  photo_file_name      :string(255)
#  photo_content_type   :string(255)
#  photo_file_size      :integer
#  photo_updated_at     :datetime
#  fullname             :string(255)
#  friend_request_email :boolean          default(TRUE)
#  message_notify_email :boolean          default(TRUE)
#  country              :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :available, :birthdate, :fb_pic_large, :fb_pic_small, :first_rating, 
  :firstname, :gender, :has_played, :lastname, :location, :password_digest, 
  :password, :email, :zip, :fb_id, :signup_method, :photo, :friend_request_email, 
  :message_notify_email, :country, :lat, :long
  
  has_secure_password
  acts_as_messageable

  has_attached_file :photo, styles: {
    square: '30x30>',
    small: '75x75>',
    large: '150x300>'
    },
    :default_url => "/assets/profile/:gender/:style/missing.png"

    validates :firstname, :presence => true
    validates :lastname, :presence => true
    validates :email, :presence => true, :format => {:with => VALID_EMAIL}, :uniqueness => {:case_sensitive => false}
    validates :password, :length => {:minimum => 6}, :on => :create
    validates :birthdate, :presence => true
    validates :gender, :presence =>  true
    validate :age_above_13, :unless => "birthdate.nil?"

    geocoded_by :zip_and_country, :latitude => :lat, :longitude => :long


    before_validation :downcase_email, :set_full_name
    after_validation :geocode, :on => :create
    after_validation :geocode, :if => lambda{|obj| obj.zip_changed? || obj.country_changed?}


    has_many :invitations, :foreign_key => "inviter_id"
    has_many :reverse_invitations, :foreign_key => "invitee_id", :class_name => "Invitation"

    has_many :invitees, :through => :invitations, :source => :invitee
    has_many :inviters, :through => :reverse_invitations, :source => :inviter

    has_many :friendships, :foreign_key => "friender_id", :dependent => :destroy
    has_many :reverse_friendships, :foreign_key => "friended_id", :class_name => "Friendship", :dependent => :destroy
    has_many :friendees, :through => :friendships, :source => :friended
    has_many :frienders, :through => :friendships, :source => :friender

    scope :without_user, lambda{|user| user ? {:conditions => ["id != ?", user.id]} : {} }


    def facebook?
      self.signup_method == FACEBOOK
    end

    def set_fb_square_pic(graph)
      self.fb_pic_square = graph.get_picture(self.fb_id, :type => "square", :height => 30, :width => 30)
      self.save
    end

    def set_fb_large_pic(graph)
      self.fb_pic_large = graph.get_picture(self.fb_id, :type => "large")
      self.save
    end

    def set_fb_small_pic(graph)
      self.fb_pic_small = graph.get_picture(self.fb_id, :type => "small")
      self.save
    end

    def invite(email,  method)
      invitation = Invitation.new(:inviter_id => self.id, :email => email, :invite_method => method)
      invitation.save
    end

    def friend(friendee)
      unless self.id == friendee.id
        friendship = self.friendships.create(:friended_id => friendee.id)
        friendship.email_request
        friendship
      end
    end

    def accept(friender)
      friendship = Friendship.find_by_friender_id_and_friended_id(friender.id, self.id)
      friendship.make_mutual
      friendship
    end

    def unfriend(friendee)
      friendship = self.friendships.find_by_friended_id(friendee.id)
      if friendship.mutual?
        friendship.reverse.destroy
      end
      friendship.destroy
    end

    def friend?(friend)
      friendship = self.friendship(friend)
      friendship ? friendship.mutual? : false
    end

    def friendship(friend)
      Friendship.find_by_friender_id_and_friended_id(self.id, friend.id)
    end

    def friendship_mutual(friend)
      self.friendships.mutual.find_by_friended_id(friend.id)
    end

    def friendship_requested_by(friender)
      friender.friendships.not_accepted.find_by_friended_id(self.id)
    end

    def friendship_requested_to(friend)
      self.friendships.not_accepted.find_by_friended_id(friend.id)
    end


    def friends
      self.friendships.mutual.pluck(:friended_id).map{|id| User.find(id)}
    end

    def friend_requests
      self.friendships.not_accepted.pluck(:friended_id).map{|id| User.find(id)}
    end

    def friends_pending
      self.reverse_friendships.not_accepted.pluck(:friender_id).map{|id| User.find(id)}
    end

    def message_notify(object)
      self.message_notify_email ? self.email : nil
    end

    def message_email_notify(receipt, recipients)
      recipients.each{|recipient| CustomMessageMailer.send_email(receipt, recipient).deliver if recipient.message_notify_email}
    end

    def recommended_players(zip_param, country_param, request, distance)
    if zip_param && country_param 
      User.near(Geocoder.coordinates("#{zip_param} #{country_param}"), distance)
      elsif (self.lat.blank? || self.long.blank? )
       User.near([request.location.latitude, request.location.longitude], 30)
      else
        self.nearbys(distance)
      end
      
    end




    private
    def age_above_13
     if self.birthdate > 13.years.ago.to_date
      errors.add(:birthdate, "cannot be less than 13 years old")
    end
  end

  def downcase_email
  	self.email = self.email.downcase
  end

  def set_full_name
    self.fullname = "#{self.firstname} #{self.lastname}"
  end

  def zip_and_country
    "#{self.zip} #{self.country}"
  end

end
