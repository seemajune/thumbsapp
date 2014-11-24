class AddInTheatersToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :in_theaters, :string
  end
end
