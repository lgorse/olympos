class AddMessageNotificationToUser < ActiveRecord::Migration
  def change
  	add_column :users, :message_notify_email, :boolean, :default => true
  end
end
