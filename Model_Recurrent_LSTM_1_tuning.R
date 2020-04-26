#Recurrent LSTM model for tuning

valoutput <- paste(QNo, "val.csv", sep="")

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

