class CreateFairnessRatings < ActiveRecord::Migration
  def change
    create_table :fairness_ratings do |t|
      t.integer :match_id
      t.integer :rater_id
      t.integer :rated_id
      t.integer :rating

      t.timestamps
    end
  end
end
