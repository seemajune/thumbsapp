class MoviesController < ApplicationController
  
  def index
    @bf = BadFruit.new('hk73sdh9btjw5w9t6m2cws9p')
    @in_theaters = @bf.lists.in_theaters
    @in_theaters.each do |movie|
        Movie.create(:title => movie.name)
    end
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end


end
