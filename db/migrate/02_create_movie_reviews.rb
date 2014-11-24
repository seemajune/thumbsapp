class CreateMovieReviews < ActiveRecord::Migration
  def change
    create_table :movie_reviews do |t|
      t.text :quote
      t.integer :movie_id

      t.timestamps
    end
  end
end
