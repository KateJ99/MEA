# Model 1 Q25

##model 1 - train embedding plus simple stacked feedforward
##Q25

#20 words is maximum length response for Q25
#508 different "words" used in q25

##prep data for embedding
text <- Q25train$ResponseNoPunc
##come back to make this k-fold validation?
training_samples <- 600
validation_samples <- 132
max_words = 508
max_len = 20
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
cat("Found",length(word_index), "unique tokens.\n")
data <-pad_sequences(sequences, maxlen = max_len)
labels <- as.array(Q25train$AgreedMark)
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
  layer_embedding(input_dim = max_words, output_dim = 16, input_length = max_len) %>%
  layer_flatten() %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 32, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics =c("acc")
)
summary(model)

#need to tweak epochs and batch size
history <- model %>% fit(
  x_train, y_train,
  epochs = 10,
  batch_size = 16,
  validation_data = list(x_val,y_val)
)

##look at specific responses
trainingtext <- text[training_indices]
validationtext <- text[validation_indices]
predictions <- model %>% predict(x_val)

output <- data.frame(validationtext,y_val,predictions)

write.csv(output, file = "Q25val.csv")

