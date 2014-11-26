class CreateSentiments < ActiveRecord::Migration
  def change
    create_table :sentiments do |t|
      t.decimal :score
      t.integer :movie_review_id

      t.timestamps
    end
  end
end
