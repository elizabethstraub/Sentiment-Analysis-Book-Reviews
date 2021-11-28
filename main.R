#Install required packages
install.packages("tm")  #text mining
install.packages("SnowballC") #text stemming
install.packages("wordcloud") #word-cloud generator
install.packages("ggplot2") #plotting graphs
install.packages("syuzhet") #sentiment analysis
install.packages("RColorBrewer") #color palettes

#Load Libraries
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")

#read CSV file
data <- read.csv('C:\\Projects - Coding\\Kindle Book Reviews - R\\kindle_review_preprocessed .csv')

#review data - number of columns
print (ncol(data))

#review data - Col Names
print(colnames(data))

#review data - number of rows
print(nrow(data))

# Quick View of the data
head(data)

# Load the data as a corpus
TextDoc  <- Corpus(VectorSource(data$review))

#Clean Data - Remove special characters by replacing "/", "!", "@" and "|" with space & remove punctuation
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
TextDoc <- tm_map(TextDoc, toSpace, "/")
TextDoc <- tm_map(TextDoc, toSpace, "!")
TextDoc <- tm_map(TextDoc, toSpace, "@")
TextDoc <- tm_map(TextDoc, removePunctuation)

#Clean Data - Remove stopwords, numbers & whitespace
TextDoc <- tm_map(TextDoc, removeWords, stopwords("english"))
TextDoc <- tm_map(TextDoc, removeNumbers)
TextDoc <- tm_map(TextDoc, stripWhitespace)

#Clean Data - make all text  lower case
TextDoc <- tm_map(TextDoc, content_transformer(tolower))

#Clean Data - Stem (setting to root base of each word)
TextDoc <- tm_map(TextDoc, stemDocument)

#EDA - review occurance of each word with a term-document matrix
TextDoc_dtm <- TermDocumentMatrix(TextDoc)
dtm_m <- as.matrix(TextDoc_dtm)

#Sort by descearing value of frequency
dtm_v <- sort(rowSums(dtm_m),decreasing=TRUE)
dtm_d <- data.frame(word = names(dtm_v),freq=dtm_v)

# Display the top 5 most frequent words
head(dtm_d, 5)

#Represented as a Bar Plot
barplot(dtm_d[1:5,]$freq, las = 2, names.arg = dtm_d[1:5,]$word,
        col ="lightblue", main ="Top 5 most frequently occuring words",
        xlab = "Word", ylab = "Word frequencies")

#Represented as a pie chart
x <- c(15696, 11329, 10921,6580,6019)
labels <- c("book", "stori", "read","like","one")
pie(x, labels, main = "Top 5 Most Frequently Occuring Words", col = rainbow(length(x)))

#Represented as a wordcloud
set.seed(1234)
wordcloud(words = dtm_d$word, freq = dtm_d$freq, min.freq = 7,
          max.words=100, random.order=FALSE, rot.per=0.40,
          colors=brewer.pal(8, "Set1"))

#EDA - Word association using correlation for words that occur min 10 times.
findAssocs(TextDoc_dtm_d, terms = findFreqTerms(TextDoc_dtm_d, lowfreq = 10), corlimit = 0.25)

#EDA - Sentiment analyasis using get_sentiment() function and method
syuzhet_vector <- get_sentiment(data$reviewText, method="syuzhet")

#EDA - see the first row of the vector
head(syuzhet_vector)

#EDA - summary statistics of the vector
summary(syuzhet_vector)

#EDA - bing (binary scale with -1 being negative and +1 being positive sentiment)
bing_vector <- get_sentiment(data$reviewText, method="bing")
head(bing_vector)
summary(bing_vector)

#EDA - affin ( integer scale ranging from -5 to +5)
afinn_vector <- get_sentiment(data$reviewText, method="afinn")
head(afinn_vector)
summary(afinn_vector)

#EDA - compare the first row of each vector using sign function
rbind(
  sign(head(syuzhet_vector)),
  sign(head(bing_vector)),
  sign(head(afinn_vector))
)

#EDA - Emotion classification with NRC
# Then view top 10 lines of the get_nrc_sentiment dataframe
d<-get_nrc_sentiment(data$reviewText)
head (d,10)

#Transpose data
td<-data.frame(t(d))

#EDA - column sums across rows for each level of a grouping variable.
#then transform and clean
td_new <- data.frame(rowSums(td[2:253]))

names(td_new)[1] <- "count"
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new2<-td_new[1:8,]

#Visual #1 - count of words associated with each sentiment
quickplot(sentiment, data=td_new2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments")

#Visual #2- count of words associated with each sentiment (as a %)
barplot(
  sort(colSums(prop.table(d[, 1:8]))),
  horiz = TRUE,
  cex.names = 0.7,
  las = 1,
  main = "Emotions in Text", xlab="Percentage"
)
