class WelcomeController < ApplicationController
  def index
     @bf = BadFruit.new('hk73sdh9btjw5w9t6m2cws9p')

     @in_theaters = @bf.lists.in_theaters
  end
end
