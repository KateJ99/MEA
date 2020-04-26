##Q19 

QNo <- "Q19"
setseed <- 24

#call data prep to read in, explore & tidy data
source(file = "DataPrep.R", echo = TRUE)

#define item specific vars
training_samples <- 700
validation_samples <- 226
max_words = 655
max_len = 26

##call tokenise to prepare data for model
source(file = "Tokenise.R", echo = TRUE)

training_run("Model_StackedDense_1_tuning.r")

##call tuning runs and set flags for different hyperparameters
runs <- tuning_run("Model_StackedDense_1.r", flags = list(
  units1 = c(64,32),
  units2 = c(32,16),
  units3 = c(32,16),
  units4 = c(32,16),
  dropout1 = c(0.2),
  dropout2 = c(0.2),
  dropout3 = c(0.2),
  batch_size = c(12,24)
))
y

##runs/2020-04-24T17-15-07Z	 best run 32 32 32 32 12
##runs/2020-04-24T16-29-13Z	128 16 32 32


##call tuning runs and set flags for different hyperparameters
runs <- tuning_run("Model_StackedDense_1.r", flags = list(
  units1 = c(128),
  units2 = c(16),
  units3 = c(32),
  units4 = c(32),
  dropout1 = c(0.2,0.25,0.3),
  dropout2 = c(0.2,0.25,0.3),
  dropout3 = c(0.2,0.25,0.3),
  batch_size = c(24,32)
))
y



copy_run(ls_runs(metric_val_acc >= 0.90), to = "best-runs")

y
View(runs[order(runs$metric_val_acc, decreasing = TRUE), ])

ls_runs(metric_val_acc > 0.88, order = metric_val_acc)
View(ls_runs())

##run best model with k fold validation


