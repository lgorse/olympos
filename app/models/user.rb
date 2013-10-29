# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  firstname       :string(255)
#  lastname        :string(255)
#  password_digest :string(255)
#  fb_id           :integer
#  birthdate       :date
#  zip             :integer
#  lat             :float
#  long            :float
#  fb_pic_small    :string(255)
#  fb_pic_large    :string(255)
#  gender          :integer
#  first_rating    :integer
#  has_played      :boolean          default(FALSE)
#  available_times :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :available, :birthdate, :fb_pic_large, :fb_pic_small, :first_rating, 
  				  :firstname, :gender, :has_played, :lastname, :location, :password_digest, 
  				  :password, :email, :zip

  has_secure_password

  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :email, :presence => true, :format => {:with => VALID_EMAIL}, :uniqueness => {:case_sensitive => false}
  validates :password, :length => {:minimum => 6}, :on => :create
  validates :birthdate, :presence => true
  validate :age_above_13, :unless => "birthdate.nil?"

  before_validation :downcase_email





private
  def age_above_13
  	if self.birthdate > 13.years.ago.to_date
  		errors.add(:birthdate, "cannot be less than 13 years old")
  	end
  end

  def downcase_email
  	self.email = self.email.downcase
  end

end
