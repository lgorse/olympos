class AddMatchNotifyToUser < ActiveRecord::Migration
  def change
    add_column :users, :match_notify_email, :boolean, :default => true
  end
end
