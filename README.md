thumbsapp
=========

thumbsapp is a natural language processing application that predicts the sentiment of movie reviews on a 5 point scale, using the Stanford CoreNLP.

The sentiment results are displayed in an interactive graphical tree hierarchy, where users can click once to toggle/collapse subtrees. Users can double click and are prompted to information to update the sentiment value of any particular node. The new value gets submitted back to our model with is repeatedly trained with the new data to enhance accuracy.

After running ```bundle install```, users will need to download the models from [here](http://central.maven.org/maven2/edu/stanford/nlp/stanford-corenlp/3.5.0/stanford-corenlp-3.5.0.jar) and extract them into the bin directory of the newly installed stanford core gem.