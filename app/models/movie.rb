
require_relative "../../config/environment"
# require 'badfruit'

class Movie < ActiveRecord::Base

  has_many :in_theaters
  # attr_accessor :movies, :choice
  BF = BadFruit.new('hk73sdh9btjw5w9t6m2cws9p')

  def initialize
    @in_theaters = BF.lists.in_theaters
  end


end

