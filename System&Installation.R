###System & installation
#Install Keras

##This sequence worked successfully to install keras after a number of installation errors. Checking no to the pop 
## to update from source and no to update dependencies in the keras installation (option 3) worked.
##I also needed to install python & miniconda outside of R.

install.packages("pacman")
library(pacman)

install.packages("glue")

install.packages("devtools")
require(devtools)
#interface between r & python
install.packages("reticulate")
library(reticulate)
install.packages("yaml")
library(yaml)
#deep learning back end
install.packages("tensorflow")
library(tensorflow)
install_github("rstudio/keras")
3
library(keras)
#these packages help log training runs to tune hyperparameters
p_load(tfruns)
p_load(tfestimators)
##package to evaluate ML models
p_load(yardstick)
##to explore black boc
p_load(lime)
##install rmarkdown 
p_load(rmarkdown)
##install latex for PDF from markdown
p_load(tinytex)

install_tensorflow()



#Other packages
install.packages("pacman")
library(pacman)

p_load(dplyr)
p_load(tidyverse)
p_load(hablar)
p_load(summarytools)
p_load(import)

#text mining
p_load(tm)



