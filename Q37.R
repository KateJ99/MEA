

##Q37

QNo <- "Q37"
setseed <- 647
dir.create(paste(QNo,"_log_dir", sep=""))
tensorboard(paste(QNo,"_log_dir", sep=""))

#call data prep to read in, explore & tidy data
source(file = "DataPrep.R", echo = TRUE)

#define item specific vars
training_samples <- 700
validation_samples <- 167
max_words = 729
max_len = 31


##call tokenise to prepare data for model
source(file = "Tokenise.R", echo = TRUE)

training_run("Model_StackedDense_1_tuning.r")

#text_embeddings <- get_weights(embed)[[1]]


##call tuning runs and set flags for nodes
runs <- tuning_run("Model_StackedDense_1_tuning.r", flags = list(
  units1 = c(124,64,32),
  units2 = c(64,32,16),
  units3 = c(32,16),
  units4 = c(32,16),
  dropout1 = c(0.2),
  dropout2 = c(0.2),
  dropout3 = c(0.2),
  batch_size = c(12,24)
))
y

View(runs[order(runs$metric_val_acc, decreasing = TRUE), ])

#124 32 32 16 batch size 24



##call tuning runs and set flags for different hyperparameters
runs <- tuning_run("Model_StackedDense_1_tuning.r", flags = list(
  units1 = c(124),
  units2 = c(32),
  units3 = c(32),
  units4 = c(16),
  dropout1 = c(0.2,0.25,0.3),
  dropout2 = c(0.2,0.25,0.3),
  dropout3 = c(0.2,0.25,0.3),
  batch_size = c(24)
))
y

##dropout 30 25 30






copy_run(ls_runs(metric_val_acc >= 0.85), to = "Q37best-runs")

y


#ls_runs(metric_val_acc > 0.88, order = metric_val_acc)
View(ls_runs())

##run best model with k fold validation


kfoldruns <- training_run("Model_StackedDense_1_kfold.r", flags = list(units1 = 124, 
                                                          units2 = 32,
                                                          units3 = 32,
                                                          units4 = 16,
                                                          dropout1 = 0.3,
                                                          dropout2 = 0.25,
                                                          dropout3 = 0.3,
                                                          batch_size = 24,
                                                          epochs = 9))




training_run("Model_Recurrent_LSTM_1_tuning.r")


##call tuning runs and set flags for different hyperparameters
runs <- tuning_run("Model_Recurrent_LSTM_1_tuning.r", flags = list(
  units1 = c(64,32),
  units2 = c(64,32),
  units3 = c(64,32),
  units4 = c(64,32),
  dropout1 = c(0.2),
  dropout2 = c(0.2),
  dropout3 = c(0.2),
  batch_size = c(24)
))
y

#32 64 64 32

##call tuning runs and set flags for different hyperparameters
runs <- tuning_run("Model_Recurrent_LSTM_1_tuning.r", flags = list(
  units1 = c(32),
  units2 = c(64),
  units3 = c(64),
  units4 = c(32),
  dropout1 = c(0.2,0.25,0.3),
  dropout2 = c(0.2,0.25,0.3),
  dropout3 = c(0.2,0.25,0.3),
  batch_size = c(24)
))
y

View(runs[order(runs$metric_val_acc, decreasing = TRUE), ])
#25 30 30
