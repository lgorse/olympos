class AddUserSquareFbPhoto < ActiveRecord::Migration
  def change
  	add_column :users, :fb_pic_square, :string
  end
end
