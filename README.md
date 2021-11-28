Using sentiment analysis and word association analysis to understand a small subset of dataset of book reviews from Amazon Kindle Store category.
The dataset contains a total of 982,619 entries and each product has at least 5 reviews.

This project is demonstration of how to create a word frequency table and plot a word cloud, to identify prominent themes occurring in the review.
It explored four methods to generate sentiment scores, which proved useful in assigning a numeric value to strength (of positivity or negativity) of sentiments in the text and allowed interpreting that the average sentiment through the text is trending positive.
Using an emotion classification with NRC sentiment to create two plots to analyze and interpret emotions found in the text.

This is benificial for understanding how people rate usefulness of a review and what factors influence "helpfulness" of a review.


Packages used:
Tm for text mining
Snowballc for stemming
Wordcloud for generating the wordcloud plot.
RColorBrewer for color palettes used in various plots
syuzhet for sentiment scores and emotion classification
ggplot2 for plotting graphs


This dataset is from Amazon product data, Julian McAuley, UCSD website. 
http://jmcauley.ucsd.edu/data/amazon/
