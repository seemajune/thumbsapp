class MoviesController < ApplicationController
  
  def index
    Movie.find_or_create_movies
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.movie_reviews
    @reviews.each {|review| review.find_or_create_sentiment}
  end


end
