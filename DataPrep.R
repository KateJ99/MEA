##Data prep generic

## Data preparation 

##Need to have installed all packages in System&Installation.R
##Need to have defined QNo, Random Seed




##defining question specific filenames
filename <- paste("C:/Users/katea/Documents/MEA/Dissertation/Data/Dataset/", QNo, ".csv", sep="")
wordcountcsv <- paste(QNo, "wordcount.csv", sep="")
trainsummaryfile <- paste(QNo, "train.html", sep="")
testsummaryfile <- paste(QNo, "test.html", sep="")


##REad in data
Qdata <- read.csv(file = filename, header=TRUE, sep = ",", stringsAsFactors = FALSE)
head(Qdata)
str(Qdata)


#remove omits.
Qdata <- subset(Qdata,AgreedMark != "-")
summary(Qdata)

#tidy up variables
Qdata$Coder1 <- as.integer(Qdata$Coder1) 
Qdata$Coder2 <- as.integer(Qdata$Coder2)
Qdata$AgreedMark <- as.integer(Qdata$AgreedMark)
Qdata$gender <- as.factor(Qdata$gender)
Qdata$GOR <- as.factor(Qdata$GOR)
str(Qdata)
summary(Qdata)


#remove punctuation & capitalisation from responses

Qdata$ResponseNoPunc <- tolower(removePunctuation(Qdata$Response, preserve_intra_word_contractions = TRUE))

Qdata$duplicated <- as.numeric(duplicated(Qdata$ResponseNoPunc))

text <- Qdata$ResponseNoPunc

#tokenising here to explore the word index - number of words used, misspellings etc
#want to tokenise all words here so setting max words quite high but might need to adjust if there are more 
max_words = 2000
tokenizer <- text_tokenizer(num_words = max_words) %>%
  fit_text_tokenizer(text)
#sequences <- texts_to_sequences(tokenizer, text)
word_index = tokenizer$word_index
word_count <- tokenizer$word_counts
write.csv(word_count,file = wordcountcsv)

#add word count for each entry
Qdata$wordcount <- sapply(strsplit(Qdata$ResponseNoPunc, " "), length)

summary(Qdata$wordcount)

##Subset the data into unique & duplicated sets
Qdataunique <- subset(Qdata,Qdata$duplicated == 0)
Qdataduplicates <- subset(Qdata,Qdata$duplicated == 1)


#divide unique sample into test/train set. Test set is generous at this point as better to be cautious
#and add to training than to expose test set to model.

set.seed(setseed)
train <- sample(nrow(Qdataunique), size = nrow(Qdataunique)*0.75, replace = F)
Qtrain <- Qdataunique[train,]
Qtest <- Qdataunique[-train,]

#check for duplicates between the test & train set
dplyr::intersect(Qtrain, Qtest)

#no rows duplicated.

view(dfSummary(Qtrain),file = trainsummaryfile)
view(dfSummary(Qtest), file = testsummaryfile)



