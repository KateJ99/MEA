
##set up flags to tune hyperparams
FLAGS <- flags(
  flag_integer("units1", 32),
  flag_integer("units2", 32),
  flag_integer("units3", 32),
  flag_integer("units4", 32),
  flag_numeric("dropout1",0.2),
  flag_numeric("dropout2",0.2),
  flag_numeric("dropout3",0.2),
  flag_integer("batch_size",12)
)

set.seed = setseed
k <- 5
indices <- sample(1:nrow(data))
folds <- cut(indices, breaks = 5, labels = FALSE)

validation_scores <- c()
for (i in 1:k) {
  validation_indices <- which(folds==1, arr.ind = TRUE)
  x_val <- data[validation_indices,]
  y_val <- labels[validation_indices]
  x_train <- data[-validation_indices,]
  y_train <- labels[-validation_indices]
  
  ##model is just to try out - need to adapt
  model <- keras_model_sequential() %>%
    layer_embedding(input_dim = max_words, output_dim = 16, input_length = max_len) %>%
    layer_flatten() %>%
    layer_dense(units = FLAGS$units1, activation = "relu") %>%
    layer_dropout(rate=FLAGS$dropout1) %>%
    layer_dense(units = FLAGS$units2, activation = "relu") %>%
    layer_dropout(rate=FLAGS$dropout2) %>%
    layer_dense(units = FLAGS$units3, activation = "relu") %>%
    layer_dropout(rate=FLAGS$dropout3) %>%
    layer_dense(units = FLAGS$units4, activation = "relu") %>%
    layer_dense(units = 1, activation = "sigmoid")
  
  model %>% compile(
    optimizer = "rmsprop",
    loss = "binary_crossentropy",
    metrics =c("acc")
  )
  summary(model)
  
  history <- model %>% fit(
    x_train, y_train,
    epochs = 10,
    batch_size = FLAGS$batch_size,
    validation_data = list(x_val,y_val))
  results <- model %>% evaluate(x_val, y_val)
  validation_scores <- c(validation_scores, results$acc)
  
  ##look at specific responses
  trainingtext <- text[training_indices]
  validationtext <- text[validation_indices]
  predictions <- model %>% predict(x_val)
  
  output <- data.frame(validationtext,y_val,predictions)
  
  valcsv <- paste(QNo,"val",i,".csv", sep="")
  
  write.csv(output, file = valcsv)
  
  
}
validation_score <- mean(validation_scores)
validation_score
