#Data prep Q37

## Data preparation 

##Need to have installed all packages in System&Installation.R

##Read in data 

Q37data <- read.csv(file = "C:/Users/katea/Documents/MEA/Dissertation/Data/Dataset/Q37.csv", header=TRUE, sep = ",", stringsAsFactors = FALSE)
head(Q37data)
str(Q37data)


#remove omits.
Q37data <- subset(Q37data,AgreedMark != "-")
summary(Q37data)

#tidy up variables
Q37data$Coder1 <- as.integer(Q37data$Coder1) 
Q37data$Coder2 <- as.integer(Q37data$Coder2)
Q37data$AgreedMark <- as.integer(Q37data$AgreedMark)
Q37data$gender <- as.factor(Q37data$gender)
Q37data$GOR <- as.factor(Q37data$GOR)
str(Q37data)
summary(Q37data)


#remove punctuation & capitalisation from responses

Q37data$ResponseNoPunc <- tolower(removePunctuation(Q37data$Response, preserve_intra_word_contractions = TRUE))



Q37data$duplicated <- as.numeric(duplicated(Q37data$ResponseNoPunc))

text <- Q37data$ResponseNoPunc

#tokenising here to explore the word index - number of words used, misspellings etc
#want to tokenise all words here so setting max words quite high but might need to adjust if there are more 
max_words = 2400
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
#sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
word_count <- tokenizer$word_counts
write.csv(word_count,file = "Q37wordcount.csv" )

#add word count for each entry
Q37data$wordcount <- sapply(strsplit(Q37data$ResponseNoPunc, " "), length)

summary(Q37data$wordcount)

##Subset the data into unique & duplicated sets
Q37dataunique <- subset(Q37data,Q37data$duplicated == 0)
Q37dataduplicates <- subset(Q37data,Q37data$duplicated == 1)


#divide unique sample into test/train set. Test set is generous at this point as better to be cautious
#and add to training than to expose test set to model.
x <- sample(0:1000,1)
x
#647
set.seed(647)
train <- sample(nrow(Q37dataunique), size = nrow(Q37dataunique)*0.75, replace = F)
Q37train <- Q37dataunique[train,]
Q37test <- Q37dataunique[-train,]

#check for duplicates between the test & train set
dplyr::intersect(Q37train, Q37test)

#no rows duplicated.

view(dfSummary(Q37train))
view(dfSummary(Q37test))



