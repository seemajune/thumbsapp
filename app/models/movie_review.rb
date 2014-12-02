class MovieReview < ActiveRecord::Base
  belongs_to :movie
  has_one :sentiment

  def find_or_create_sentiment
    sentiment = Sentiment.find_by(movie_review_id: self.id) || self.create_sentiment
  end

  def create_sentiment
    self.build_sentiment
    sentiment.score = sentiment.get_sentiment
    sentiment.save
  end
end
