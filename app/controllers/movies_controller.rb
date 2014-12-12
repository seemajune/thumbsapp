class MoviesController < ApplicationController

  def index
    Movie.find_or_create_movies
    @movies = Movie.all
  end

  def show
    @movies = Movie.all
    @movie = Movie.find(params[:id])
    @reviews = @movie.movie_reviews
    @reviews.each {|review| review.find_or_create_sentiment}

  end

def suggest
  @phrase = params[:phrase]
  @score = params[:score]



end


end
