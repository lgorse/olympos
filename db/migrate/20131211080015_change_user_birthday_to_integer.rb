class ChangeUserBirthdayToInteger < ActiveRecord::Migration
  def change
  	add_column :users, :birthyear, :integer
  	User.reset_column_information
  	User.all.each do |user|
  		user.birthyear = user.birthdate.year
  		user.save!
  	end
  	remove_column :users, :birthdate
  	rename_column :users, :birthyear, :birthdate
  end
end
