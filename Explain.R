###Explain model

##Draft to explain features in model
#https://keras.rstudio.com/articles/examples/text_explanation_lime.html

##this code used the lime package to identify features in the text which the model uses to contribute to labels


get_embedding_explanation <- function(text) {
  
  tokenizer %>% fit_text_tokenizer(text)
  
  text_to_seq <- texts_to_sequences(tokenizer, text)
  sentences <- text_to_seq %>% pad_sequences(maxlen = max_len)
}



sentence_to_explain <- Qdata$ResponseNoPunc[1:20]
sentence_to_explain

explainer <- lime(sentence_to_explain, model = model, preprocess = get_embedding_explanation)


explanation <- lime::explain(sentence_to_explain, explainer, n_labels = 1, n_features = 3,n_permutations = 1e4)


plot_text_explanations(explanation)
plot_features(explanation)
##creates an interactive portal to explore any responses
interactive_text_explanations(explainer)
