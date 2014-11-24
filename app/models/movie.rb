
require_relative "../../config/environment"
require 'badfruit'

class Movie < ActiveRecord::Base
  has_many :movie_reviews
  # has_many :in_theaters

end

