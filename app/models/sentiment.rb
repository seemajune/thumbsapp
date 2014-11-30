require 'java'
class Sentiment < ActiveRecord::Base

  belongs_to :movie_review
  Treat::Core::DSL
  StanfordCoreNLP.load_class('SentimentCoreAnnotations', 'edu.stanford.nlp.sentiment')
  StanfordCoreNLP.load_class('RNNCoreAnnotations', 'edu.stanford.nlp.neural.rnn')
  SENTIMENT_TEXT =  ["Very Negative","Negative", "Neutral", "Positive", "Very Positive"]

  def get_sentiment(review)
    get_annotation(review)
    @values = []
    @text.get(:sentences).each do |sentence|
      tree = StanfordCoreNLP::RNNCoreAnnotations
      @children = StanfordCoreNLP::RNNCoreAnnotations
      #new
      # binding.pry
      #get actual sentiment values
      @values << tree.getPredictedClass(sentence.get:annotated_tree)
      node_tree = sentence.get:annotated_tree
      nodes = node_tree.post_order_node_list.to_a.reverse
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

  def get_json(nodes)
    file_name = "json.txt"
    json_string = ''
    #binding.pry
    nodes.each_with_index do |node, index|
      json_string << "#{index}. {'name':\n#{node.to_s}\n'children':[\n"
      #f.puts("#{node.to_s}\n")
      if has_children?(node)
        @children = node.get_children_as_list.to_a.reverse

      else
        puts "end here"
        json_string << " \n]}\n"

        # if @children == []
        #   json_string <<"children: ["

        #   json_string <<" ]}\n" if @children == []
        #   getJson(@children) if @children != []
      end
    end
    #binding.pry
    file = File.open(file_name, "w+"){|file| file.puts json_string}
    # puts json_string
    #file.close

    return @children.to_s if @children == []
  end

  def has_children?(node)
    node.get_children_as_list.to_a.nil?
  end

end
