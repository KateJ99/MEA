#Recurrent LSTM model for tuning

valoutput <- paste(QNo, "val.csv", sep="")

##set up flags to tune hyperparams
FLAGS <- flags(
  flag_integer("units1", 32),
  flag_integer("units2", 32),
  flag_integer("units3", 32),
  flag_integer("units4", 32),
  flag_numeric("dropout1",0.2),
  flag_numeric("dropout2",0.2),
  flag_numeric("dropout3",0.2),
  flag_integer("batch_size",12),
  flag_integer("epoch",10)
)

##model is just to try out - need to adapt
model <- keras_model_sequential() %>%
  layer_embedding(input_dim = max_words, output_dim = 32, input_length = max_len) %>%
  layer_lstm(units = 32, return_sequences = TRUE) %>%
  layer_dropout(rate=FLAGS$dropout1) %>%
  layer_lstm(units = 32, return_sequences = TRUE) %>%
  layer_dropout(rate=FLAGS$dropout2) %>%
  layer_lstm(units = 32, return_sequences = TRUE) %>%
  layer_dropout(rate=FLAGS$dropout3) %>%
  layer_lstm(units = 32) %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  optimizer = "rmsprop",
  loss = "binary_crossentropy",
  metrics =c("acc")
)
summary(model)

history <- model %>% fit(
  x_train, y_train,
  epochs = FLAGS$epoch,
  batch_size = FLAGS$batch_size,
  validation_data = list(x_val,y_val)
)

##look at specific responses
trainingtext <- text[training_indices]
validationtext <- text[validation_indices]
predictions <- model %>% predict(x_val)

output <- data.frame(validationtext,y_val,predictions)

write.csv(output, file = valoutput)

