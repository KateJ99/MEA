## Data preparation 

##Need to have installed all packages in System&Installation.R

##Read in data 

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


#remove punctuation & capitalisation from responses

Q2data$ResponseNoPunc <- tolower(removePunctuation(Q2data$Response, preserve_intra_word_contractions = TRUE))



Q2data$duplicated <- as.numeric(duplicated(Q2data$ResponseNoPunc))

text <- Q2data$ResponseNoPunc

max_words = 2400
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
#sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
word_count <- tokenizer$word_counts
write.csv(word_count,file = "Q2wordcount.csv" )


##Subset the data into unique & duplicated sets
Q2dataunique <- subset(Q2data,Q2data$duplicated == 0)
Q2dataduplicates <- subset(Q2data,Q2data$duplicated == 1)


#divide unique sample into test/train set. Test set is generous at this point as better to be cautious
#and add to training than to expose test set to model.
x <- sample(0:1000,1)
x
#858
set.seed(858)
train <- sample(nrow(Q2dataunique), size = nrow(Q2dataunique)*0.75, replace = F)
Q2train <- Q2dataunique[train,]
Q2test <- Q2dataunique[-train,]

#check for duplicates between the test & train set
dplyr::intersect(Q2train, Q2test)

#no rows duplicated.

view(dfSummary(Q2train))
view(dfSummary(Q2test))



