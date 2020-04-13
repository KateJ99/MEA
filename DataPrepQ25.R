## Data preparation 

##Need to have installed all packages in System&Installation.R

##Read in data 

Q25data <- read.csv(file = "C:/Users/katea/Documents/MEA/Dissertation/Data/Dataset/Q25.csv", header=TRUE, sep = ",", stringsAsFactors = FALSE)
head(Q25data)
str(Q25data)


#remove omits.
Q25data <- subset(Q25data,AgreedMark != "-")
summary(Q25data)

#tidy up variables
Q25data$Coder1 <- as.integer(Q25data$Coder1) 
Q25data$Coder2 <- as.integer(Q25data$Coder2)
Q25data$AgreedMark <- as.integer(Q25data$AgreedMark)
Q25data$gender <- as.factor(Q25data$gender)
Q25data$GOR <- as.factor(Q25data$GOR)
str(Q25data)
summary(Q25data)


#remove punctuation & capitalisation from responses

Q25data$ResponseNoPunc <- tolower(removePunctuation(Q25data$Response, preserve_intra_word_contractions = TRUE))



Q25data$duplicated <- as.numeric(duplicated(Q25data$ResponseNoPunc))

text <- Q25data$ResponseNoPunc

#tokenising here to explore the word index - number of words used, misspellings etc
#want to tokenise all words here so setting max words quite high but might need to adjust if there are more
max_words = 2400
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
#sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
word_count <- tokenizer$word_counts
write.csv(word_count,file = "Q25wordcount.csv" )

#add word count for each entry
Q25data$wordcount <- sapply(strsplit(Q25data$ResponseNoPunc, " "), length)

summary(Q25data$wordcount)

##Subset the data into unique & duplicated sets
Q25dataunique <- subset(Q25data,Q25data$duplicated == 0)
Q25dataduplicates <- subset(Q25data,Q25data$duplicated == 1)


#divide unique sample into test/train set. Test set is generous at this point as better to be cautious
#and add to training than to expose test set to model.
x <- sample(0:1000,1)
x
#289
set.seed(289)
train <- sample(nrow(Q25dataunique), size = nrow(Q25dataunique)*0.75, replace = F)
Q25train <- Q25dataunique[train,]
Q25test <- Q25dataunique[-train,]

#check for duplicates between the test & train set
dplyr::intersect(Q25train, Q25test)

#no rows duplicated.

view(dfSummary(Q25train))
view(dfSummary(Q25test))



