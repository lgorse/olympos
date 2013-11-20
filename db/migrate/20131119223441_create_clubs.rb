class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :city
      t.string :street
      t.integer :zip
      t.string :country
      t.float :lat
      t.float :long

      t.timestamps
    end
    add_index :clubs, :name
    add_index :clubs, :zip
  end
end
