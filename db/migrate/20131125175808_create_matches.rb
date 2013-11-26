class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :player1
      t.integer :player2
      t.integer :winner
      t.text :player1_score
      t.text :player2_score
      t.boolean :player1_confirm, :default => false
      t.boolean :player2_confirm, :default => false
      t.boolean :confirmed, :default => false
      t.timestamps
    end
  end
end
