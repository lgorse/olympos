# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city       :string(255)
#  street     :string(255)
#  zip        :integer
#  country    :string(255)
#  lat        :float
#  long       :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Club < ActiveRecord::Base
  attr_accessible :city, :country, :lat, :long, :name, :street, :zip

  validates :name, :presence => true
  validates :zip, :presence => true, :numericality => {:only_integer => true}
  validates :country, :presence => true
end
