class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.integer :invitee_id
      t.boolean :accepted
      t.text :message
      t.string :email

      t.timestamps
    end
    add_index :invitations, :invitee_id
    add_index :invitations, :email
  end
end
