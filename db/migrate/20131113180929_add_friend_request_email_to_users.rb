class AddFriendRequestEmailToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :friend_request_email, :boolean, :default => true
  end
end
