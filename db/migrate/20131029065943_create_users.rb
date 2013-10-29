class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :password_digest
      t.integer :fb_id
      t.date :birthdate
      t.integer :zip
      t.float :lat, :precision => 6, :scale => 10
      t.float :long, :precision => 6, :scale => 10
      t.string :fb_pic_small
      t.string :fb_pic_large
      t.integer :gender
      t.integer :first_rating
      t.boolean :has_played, :default => false
      t.text :available_times
      t.timestamps
    end
    add_index :users, :fb_id
  end
end
