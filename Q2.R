
##Q2

QNo <- "Q2"
setseed <- 858

#call data prep to read in, explore & tidy data
source(file = "DataPrep.R", echo = TRUE)

#define item specific vars
training_samples <- 1000
validation_samples <- 201
max_words = 612
max_len = 28

##call tokenise to prepare data for model
source(file = "Tokenise.R", echo = TRUE)

training_run("Model_StackedDense_1_tuning.r")

##call tuning runs and set flags for nodes
runs <- tuning_run("Model_StackedDense_1_tuning.r", flags = list(
  units1 = c(124,64),
  units2 = c(64,32),
  units3 = c(32),
  units4 = c(32),
  dropout1 = c(0.2),
  dropout2 = c(0.2),
  dropout3 = c(0.2),
  batch_size = c(12,24)
))
y

View(runs[order(runs$metric_val_acc, decreasing = TRUE), ])

#64 32 32 32



##call tuning runs and set flags for different hyperparameters
runs <- tuning_run("Model_StackedDense_1_tuning.r", flags = list(
  units1 = c(64),
  units2 = c(32),
  units3 = c(32),
  units4 = c(32),
  dropout1 = c(0.2,0.25,0.3),
  dropout2 = c(0.2,0.25,0.3),
  dropout3 = c(0.2,0.25,0.3),
  batch_size = c(24)
))
y

##dropout 30 25 20



copy_run(ls_runs(metric_val_acc >= 0.95), to = "Q2best-runs")

y


ls_runs(metric_val_acc > 0.88, order = metric_val_acc)
View(ls_runs())

##run best model with k fold validation


training_run("Model_StackedDense_1_kfold.r", flags = list(units1 = 64, 
                                                          units2 = 32,
                                                          units3 = 32,
                                                          units4 = 32,
                                                          dropout1 = 0.3,
                                                          dropout2 = 0.25,
                                                          dropout3 = 0.2,
                                                          batch_size = 24))


