class UpdateUserFbIdToBigint < ActiveRecord::Migration
  def change
  	change_column :users, :fb_id, :integer, :limit => 8
  end
end
