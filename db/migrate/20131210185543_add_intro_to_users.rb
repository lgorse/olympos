class AddIntroToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :intro, :text
  end
end
