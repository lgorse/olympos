class AddSignupMethodToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :signup_method, :integer
  end
end
