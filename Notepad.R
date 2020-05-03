#Notepad

#Keeps only unique responses
Q2dataunique <- Q2data %>% distinct(ResponseNoPunc, .keep_all = TRUE)
summary(Q2dataunique)

#Save out the duplicates to add in later (do this after tokenisation)
Q2dataduplicates <- Q2data %>% find_duplicates(ResponseNoPunc)

Q2dataduplicates <- Q2dataduplicates %>%
  group_by(ResponseNoPunc) %>%
  slice(-1)

##assorted code for training runs
#https://tensorflow.rstudio.com/tools/tfruns/overview/
#runs r script and displays in r studio viewer
training_run("Model 1 Q19.r")
training_run("Model 1 Q19.r", flags = list(dropout1 = 0.2,dropout2 = 0.3))
#displays latest run
latest_run()
#compares 2 most recent runs
compare_runs()
#table comparing all runs in directory
View(ls_runs())
#moves runs to archive (empty - all, otherwise can specify)
clean_runs()

y
#code for tuning
#https://tensorflow.rstudio.com/tools/tfruns/tuning/

runs <- tuning_run("Model 1 Q19.r", flags = list(
  dropout1 = c(0.2,0.3,0.4),
  dropout2 = c(0.2,0.3,0.4),
  batch_size = c(12,24,32)
))
y

View(runs[order(runs$metric_val_acc, decreasing = TRUE), ])

##model1
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

##yardstick to eval
#https://blogs.rstudio.com/tensorflow/posts/2018-01-11-keras-customer-churn/
  
  




