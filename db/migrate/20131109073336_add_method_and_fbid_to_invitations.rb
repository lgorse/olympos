class AddMethodAndFbidToInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :method, :integer
  	add_column :invitations, :fb_id, :integer, :limit => 8
  	add_index :invitations, :fb_id
  end
end
