# DataprepQ19

## Data preparation 

##Need to have installed all packages in System&Installation.R

##Read in data 

Q19data <- read.csv(file = "C:/Users/katea/Documents/MEA/Dissertation/Data/Dataset/Q19.csv", header=TRUE, sep = ",", stringsAsFactors = FALSE)
head(Q19data)
str(Q19data)


#remove omits.
Q19data <- subset(Q19data,AgreedMark != "-")
summary(Q19data)

#tidy up variables
Q19data$Coder1 <- as.integer(Q19data$Coder1) 
Q19data$Coder2 <- as.integer(Q19data$Coder2)
Q19data$AgreedMark <- as.integer(Q19data$AgreedMark)
Q19data$gender <- as.factor(Q19data$gender)
Q19data$GOR <- as.factor(Q19data$GOR)
str(Q19data)
summary(Q19data)


#remove punctuation & capitalisation from responses

Q19data$ResponseNoPunc <- tolower(removePunctuation(Q19data$Response, preserve_intra_word_contractions = TRUE))



Q19data$duplicated <- as.numeric(duplicated(Q19data$ResponseNoPunc))

text <- Q19data$ResponseNoPunc

#tokenising here to explore the word index - number of words used, misspellings etc
#want to tokenise all words here so setting max words quite high but might need to adjust if there are more 
max_words = 2400
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
#sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
word_count <- tokenizer$word_counts
write.csv(word_count,file = "Q19wordcount.csv" )

#add word count for each entry
Q19data$wordcount <- sapply(strsplit(Q19data$ResponseNoPunc, " "), length)

summary(Q19data$wordcount)

##Subset the data into unique & duplicated sets
Q19dataunique <- subset(Q19data,Q19data$duplicated == 0)
Q19dataduplicates <- subset(Q19data,Q19data$duplicated == 1)


#divide unique sample into test/train set. Test set is generous at this point as better to be cautious
#and add to training than to expose test set to model.
x <- sample(0:1000,1)
x
#24
set.seed(24)
train <- sample(nrow(Q19dataunique), size = nrow(Q19dataunique)*0.75, replace = F)
Q19train <- Q19dataunique[train,]
Q19test <- Q19dataunique[-train,]

#check for duplicates between the test & train set
dplyr::intersect(Q19train, Q19test)

#no rows duplicated.

view(dfSummary(Q19train))
view(dfSummary(Q19test))



