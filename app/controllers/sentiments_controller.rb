class SentimentsController < ApplicationController
  respond_to :json

  def show
    @sentiment = Sentiment.find(params[:id])
    respond_with @sentiment
  end
end

    
