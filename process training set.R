# process training set #

# Start the clock!
ptm <- proc.time()
# SETUP #
gc()
setwd("C:/Users/Michael/SkyDrive/Code/GitHub/DSCapstone/Coursera-SwiftKey/final/en_US")
train=readRDS("n.train.RDS")
library(tm)
library(RWeka)

# FUNCTION DEFINITIONS #

# Make Corpus and do transformations
makeCorpus<- function(x) {
corpus<-Corpus(VectorSource(x))
# corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, content_transformer(tolower))
# corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
# corpus<- tm_map(corpus,removePunctuation)
# corpus<- tm_map(corpus,removeNumbers)
return(corpus)
}

process<- function(x) {
# Text Transformations to remove odd characters #
# replace APOSTROPHES OF 2 OR MORE with space - WHY??? that never happens..
	# output=lapply(output,FUN= function(x) gsub("'{2}"rr, " ",x))
# Replace numbers with spaces... not sure why to do that yet either.
	# output=lapply(output,FUN= function(x) gsub("[0-9]", " ",x))
# Erase commas.
x=gsub(",?", "", x)
# Erase ellipsis
x=gsub("\\.{3,}", "", x)
# Erase colon
x=gsub("\\:", "", x)
##### SENTENCE SPLITTING AND CLEANUP
# Split into sentences only on single periods or any amount of question marks or exclamation marks and -
# ok here is where you change structure fundamentally... 
x<-strsplit(unlist(x),"[\\.]{1}")
x<-strsplit(unlist(x),"\\?+")
x<-strsplit(unlist(x),"\\!+")
x<-strsplit(unlist(x),"\\-+")
# Split also on parentheses
x<-strsplit(unlist(x),"\\(+")
x<-strsplit(unlist(x),"\\)+")
# split also on quotation marks
x<-strsplit(unlist(x),"\\\"")
# remove spaces at start and end of sentences:
x<-gsub("^\\s+", "", x)
x<-gsub("\\s+$", "", x)
# Replace ~ and any whitespace around with just one space
x<-gsub("\\s*~\\s*", " ", x)
# Replace forward slash with space
x<-gsub("\\/", " ", x)
# Replace + signs with space
x<-gsub("\\+", " ", x)
# Eliminate empty and single letter values (more?)
x=x[which(nchar(x)!=1)]
x=x[which(nchar(x)!=0)]
}

# Tokenizer functions
TgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
BgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
UgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))

# Corpus, transformations, and TDM Creation
#=============================================#

corpus<-makeCorpus(train)

Ttdm<- TermDocumentMatrix(corpus, control = list(tokenize = TgramTokenizer))
gc()
Btdm<- TermDocumentMatrix(corpus, control = list(tokenize = BgramTokenizer))
gc()
Utdm<- TermDocumentMatrix(corpus, control = list(tokenize = UgramTokenizer))
gc()

rm(corpus)

#########################
#BUILD PREDICTION TABLES#
#########################

library(slam)
library(data.table)

counts=row_sums(Utdm)
rm(Utdm)
gc()
Ufreq<-data.table(grams=names(counts), counts=counts)
setkey(Ufreq,grams)

counts=row_sums(Btdm)
rm(Btdm)
gc()
Bfreq<-data.table(grams=names(counts), counts=counts)
setkey(Bfreq,grams)

counts=row_sums(Ttdm)
rm(Ttdm)
gc()
Tfreq<-data.table(grams=names(counts), counts=counts)
setkey(Tfreq,grams)
gc()

rm(counts)
#rm(train)
# Stop the clock
proc.time() - ptm # 10000 news lines: 74 secs 1.23 minutes

