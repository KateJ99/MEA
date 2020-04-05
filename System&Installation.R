###System & installation
#Install Keras

##This sequence worked successfully to install keras after a number of installation errors. Checking no to the pop 
## to update from source and no to update dependencies in the keras installation (option 3) worked.
##I also needed to install python & miniconda outside of R.

install.packages("glue")

install.packages("devtools")
require(devtools)
install.packages("reticulate")
library(reticulate)
install.packages("yaml")
library(yaml)
install.packages("tensorflow")
library(tensorflow)
install_github("rstudio/keras")
3
library(keras)
