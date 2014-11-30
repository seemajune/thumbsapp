class Sentiment < ActiveRecord::Base
  belongs_to :movie_review

  StanfordCoreNLP.load_class('SentimentCoreAnnotations', 'edu.stanford.nlp.sentiment')
  StanfordCoreNLP.load_class('RNNCoreAnnotations', 'edu.stanford.nlp.neural.rnn')
  SENTIMENT_TEXT =  ["Very Negative","Negative", "Neutral", "Positive", "Very Positive"]
  
  def get_sentiment(review)
    get_annotation(review)
    @values = []
    @text.get(:sentences).each do |sentence|
      tree = StanfordCoreNLP::RNNCoreAnnotations
      binding.pry
      #get actual sentiment values
      @values << tree.getPredictedClass(sentence.get:annotated_tree)
      #get sentiment labels
      puts sentence.get(:class_name).to_s
    end
      results
  end

  def get_annotation(review)
    pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :parse, :sentiment)
    @text = review
    @text = StanfordCoreNLP::Annotation.new(@text)
    pipeline.annotate(@text)
  end

  def results
    result = @values.inject{ |sum, elm| sum + elm }.to_f / @values.size
    puts "The result is #{result}, so this movie is classified as #{SENTIMENT_TEXT[result.to_i]}."
    result
  end

end
