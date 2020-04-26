##Tokenise 

##prep data for embedding
text <- Qtrain$ResponseNoPunc
##come back to make this k-fold validation?

tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
cat("Found",length(word_index), "unique tokens.\n")
data <-pad_sequences(sequences, maxlen = max_len)
labels <- as.array(Qtrain$AgreedMark)
cat("Shape of data tensor:", dim(data),"\n")
cat("Shape of label tensor:", dim(labels),"\n")
set.seed = setseed
indices <- sample(1:nrow(data))
training_indices <- indices[1:training_samples]
validation_indices <- indices[(training_samples+1):(training_samples + validation_samples)]

x_train <- data[training_indices,]
y_train <- labels[training_indices]

x_val <- data[validation_indices,]
y_val <- labels[validation_indices]