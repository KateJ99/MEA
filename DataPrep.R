## Data preparation 

##Read in data 
library(pacman)

p_load(tm)
library(tm)
p_load(keras)
library(keras)
p_load(tidyverse)
library(tidyverse)
p_load(dplyr)
library(dplyr)

Q2data <- read.csv(file = "C:/Users/katea/Documents/MEA/Dissertation/Data/Dataset/Q2.csv", header=TRUE, sep = ",", stringsAsFactors = FALSE)
head(Q2data)
str(Q2data)


#remove omits.
Q2data <- subset(Q2data,AgreedMark != "-")
summary(Q2data)

#tidy up variables
Q2data$Coder1 <- as.integer(Q2data$Coder1) 
Q2data$Coder2 <- as.integer(Q2data$Coder2)
Q2data$AgreedMark <- as.integer(Q2data$AgreedMark)
Q2data$gender <- as.factor(Q2data$gender)
Q2data$GOR <- as.factor(Q2data$GOR)
str(Q2data)
summary(Q2data)


#remove punctuation from responses

Q2data$ResponseNoPunc <- removePunctuation(Q2data$Response, preserve_intra_word_contractions = TRUE)

?dplyr
Q2data %>% distinct(ResponseNoPunc, .keep_all = TRUE)
