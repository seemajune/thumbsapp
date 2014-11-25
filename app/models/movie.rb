class Movie < ActiveRecord::Base
  has_many :movie_reviews
  # has_many :in_theaters

  def self.create_movies
    bf = BadFruit.new('hk73sdh9btjw5w9t6m2cws9p')
    in_theaters = bf.lists.in_theaters
    in_theaters.each do |m|
      poster = get_poster(m.posters.thumbnail)
      movie = Movie.new(:title => m.name, :poster => poster)
        #binding.pry
        begin
          m.reviews.each do |r|
            movie.movie_reviews.build(:quote => r.quote)
          end
        rescue
          puts "ran out api calls"
        end
      movie.save
    end
  end

  def self.get_poster(filename)
    filename.gsub('tmb', 'det')
  end

end

