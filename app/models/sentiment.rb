require 'java'
class Sentiment < ActiveRecord::Base

  belongs_to :movie_review

  StanfordCoreNLP.load_class('SentimentCoreAnnotations', 'edu.stanford.nlp.sentiment')
  StanfordCoreNLP.load_class('SentimentPipeline', 'edu.stanford.nlp.sentiment')
  StanfordCoreNLP.load_class('RNNCoreAnnotations', 'edu.stanford.nlp.neural.rnn')

  SENTIMENT_TEXT =  ["Very Negative","Negative", "Neutral", "Positive", "Very Positive"]

  def get_sentiment
    get_annotation
    @values = []
    @text.get(:sentences).each do |sentence|
      tree = sentence.get :annotated_tree
      StanfordCoreNLP::SentimentPipeline.setSentimentLabels(tree)

      #get actual sentiment values
      @values << StanfordCoreNLP::RNNCoreAnnotations.getPredictedClass(tree)
    end
    results
  end

  def get_json(tree)
    ret = {}
    if tree.children.count > 1
      ret['children'] = tree.children.map { |el| get_json(el) }
      ret['score'] = tree.label.to_s
    else
      ret['score'] = StanfordCoreNLP::RNNCoreAnnotations.getPredictedClass(tree)
      ret['label'] = tree.children.first.label.to_s
    end
    ret
  end

  def to_json(o)
    scores = []
    get_annotation
    json_objs = @text.get(:sentences).map do |sentence|
      tree = sentence.get :annotated_tree
      StanfordCoreNLP::SentimentPipeline.setSentimentLabels(tree)

      #get actual sentiment values
      scores << StanfordCoreNLP::RNNCoreAnnotations.getPredictedClass(tree)
      
      get_json(tree)
    end

    json_objs.one? ?
      json_objs.first.to_json :
      {children: json_objs, score: scores.reduce(:+) / scores.size}.to_json
  end

  def get_annotation
    pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :parse, :sentiment)
    @text = movie_review.quote
    @text = StanfordCoreNLP::Annotation.new(@text)
    pipeline.annotate(@text)
  end

  def results
    result = @values.inject{ |sum, elm| sum + elm }.to_f / @values.size
    puts "The result is #{result}, so this movie is classified as #{SENTIMENT_TEXT[result.to_i]}."
    result
  end

end
