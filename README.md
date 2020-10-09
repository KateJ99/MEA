 MEA
Dissertation code

Q2.R contains the following:
Question specific R script which calls modular scripts to
run data prep & training models for question 2.

DataPrep.R contains the following:
* Read in all data for each item
* Tidy up data structure
* Tidy responses- remove punctuation and capitalisation
* indicate which responses are duplicated
* Run tokeniser on responses to explore word freqs.


Notepad.R is a working file containing code that might be useful later
* Separating out duplicates without using the dup col
*** Important code for running tuning models to find best hyperparameters


System&installation.R
* notes on troubleshooting installation errors
* notes on applications which needed installing outside of R 
contains packages which need to be installed & loaded for keras to work
* Installs other packages required throughout


Model 1.R
* contains a basic model stacked model with task specific embedding for Q2
* embedding arguments: input_dim = size of vocab; output_dim - size of vector space for embedded items (can change); input_length - length of padded responses (i.e. longest response)
Flatten - needs to be here to connect a dense layer - flattens the embedding output from 2d (embedding, sequence) to 1d (embedding) of size output_dim x input_length
layer_dense - units - determines representational size of layer
layer_dropout - regularization layer to prevent overfitting; value indicates dropout rate
output layer - activation "sigmoid" produces a binary classification value between 0 and 1 where values close to 0 or 1 indicate higher confidence in classification

Model 2.R
* Contains a recurrent model to process sequences of text

To do
* read out embedding weightings for tensorboard
* amend model parameters/ add dropout 
* k fold validation
* add pre-trained embeddings
