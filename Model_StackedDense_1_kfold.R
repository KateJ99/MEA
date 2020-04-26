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
    layer_dense(units = 128, activation = "relu") %>%
    layer_dropout(rate=0.2) %>%
    layer_dense(units = 64, activation = "relu") %>%
    layer_dropout(rate=0.2) %>%
    layer_dense(units = 32, activation = "relu") %>%
    layer_dropout(rate=0.2) %>%
    layer_dense(units = 32, activation = "relu") %>%
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
    batch_size = 16,
    validation_data = list(x_val,y_val))
  results <- model %>% evaluate(x_val, y_val)
  validation_scores <- c(validation_scores, results$accuracy)
  )
}

