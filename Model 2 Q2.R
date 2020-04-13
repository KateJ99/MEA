##model 2 - train embedding plus RNN
##Q2

#28 words is maximum length response for Q2
#612 different "words" used in q2

##prep data for embedding
text <- Q2train$ResponseNoPunc
##come back to make this k-fold validation?


training_samples <- 1000
validation_samples <- 201
max_words = 628
max_len = 28
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
cat("Found",length(word_index), "unique tokens.\n")
data <-pad_sequences(sequences, maxlen = max_len)
labels <- as.array(Q2train$AgreedMark)
cat("Shape of data tensor:", dim(data),"\n")
cat("Shape of label tensor:", dim(labels),"\n")
indices <- sample(1:nrow(data))
training_indices <- indices[1:training_samples]
validation_indices <- indices[(training_samples+1):(training_samples + validation_samples)]

x_train <- data[training_indices,]
y_train <- labels[training_indices]

x_val <- data[validation_indices,]
y_val <- labels[validation_indices]

##model is just to try out - need to adapt
model <- keras_model_sequential() %>%
  layer_embedding(input_dim = 612, output_dim = 8, input_length = max_len) %>%
  layer_lstm(units = 8, return_sequences = TRUE) %>%
  layer_lstm(units = 8, return_sequences = TRUE) %>%
  layer_lstm(units = 8, return_sequences = TRUE) %>%
  layer_lstm(units = 8) %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics =c("acc")
)
summary(model)

history <- model %>% fit(
  x_train, y_train,
  epochs = 16,
  batch_size = 32,
  validation_data = list(x_val,y_val)
)

##look at specific responses
trainingtext <- text[training_indices]
validationtext <- text[validation_indices]
predictions <- model %>% predict(x_val)

output <- data.frame(validationtext,y_val,predictions)

write.csv(output, file = "Q2val.csv")

