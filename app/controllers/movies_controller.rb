class MoviesController < ApplicationController
  
  def index
    Movie.create_movies
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end


end
