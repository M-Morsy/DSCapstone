#Set working directory
setwd("C:/Users/Michael/SkyDrive/Code/GitHub/DSCapstone/Coursera-SwiftKey/final/en_US")

fileName="testData.txt"
testData <- readLines(fileName)

## REMOVAL OF STRANGE CHARACTERS##
# Replace unicode characters with spaces.
TcleanData<-iconv(testData, to='ASCII', sub=' ')
# Replace numbers and ''
TcleanData2 <- gsub("'{2}", " ", TcleanData)
TcleanData3 <- gsub("[0-9]", " ", TcleanData2)

# Split sentence into words.
TSplit<-unlist(strsplit(TcleanData3," "))
#  Find associations
TResults<-findAssocs(tdm,TSplit,corlimit=0.5)
# Eliminate numeric(0) results
TResults2 <- TResults[sapply(TResults, length) > 0] 

findAssocs(tdm,"front",corlimit=0.5)

# Bigrams
library(RWeka)
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
txtTdmBi <- TermDocumentMatrix(corpus6, control = list(tokenize = BigramTokenizer))
library(slam)
txtTdmBi2 <- rollup(txtTdmBi, 2, na.rm=TRUE, FUN = sum)

# Bigram test
findAssocs(txtTdmBi2,"case of",corlimit=0.01)

'added today' %in% Terms(txtTdmBi)
TRUE
'case of' %in% Terms(txtTdmBi)
FALSE

##----##

# FIRST RUN (2000 lines of news only.)
# TResults2
# $front
# camper    doe encamp sproul   tent 
#   0.52   0.52   0.52   0.52   0.52 

# $pound
#   donkey    humve     mule onethird 
#      0.6      0.6      0.6      0.6 
# Test sentence:
# "The guy in front of me just bought a pound of bacon, a bouquet, and a case of"

# of course, the right answer should be beer. 
# What is the problem? Well my data may be too small, let's go ahead and load in the fuller dataset...
# it could also be that i need to incorporate n-grams or focus on "case". But now I simply don't have any case in my testdata so that is a bigger problem.

##----##

## MAKE CORPUS ##
require(tm)
Tcorpus <- Corpus(VectorSource(TcleanData3))

## TOKENIZATION ## 

# REMOVE WHITESPACE:
Tcorpus1 <- tm_map(Tcorpus, stripWhitespace)
inspect(Tcorpus1) #don't see a big difference

# LOWERCASE:
Tcorpus2 <- tm_map(Tcorpus1, content_transformer(tolower))
inspect(Tcorpus2) #works

# REMOVE STOPWORDS
Tcorpus3 <- tm_map(Tcorpus2, removeWords, stopwords("english"))
inspect(Tcorpus3) # ok the has been removed...

# STEMMING
Tcorpus4 <- tm_map(Tcorpus3, stemDocument)
inspect(Tcorpus4) # Looks stemmed.

# REMOVE PUNCTUATION
Tcorpus5<- tm_map(Tcorpus4,removePunctuation)

# REMOVE NUMBERS
Tcorpus6<- tm_map(Tcorpus5,removeNumbers)

## END TOKENIZATION ##

## TOKEN ANALYSIS ##

# MAKE TERM DOCUMENT MATRIX (TDM) - a matrix of frequency counts for each word used in the Tcorpus.
Ttdm<- TermDocumentMatrix(Tcorpus6)
Tdtm<- DocumentTermMatrix(Tcorpus6)
Tdtm

## TOKEN ANALYSIS ##

# MAKE TERM DOCUMENT MATRIX (TDM) - a matrix of frequency counts for each word used in the Tcorpus.
Ttdm<- TermDocumentMatrix(Tcorpus6)
Tdtm<- DocumentTermMatrix(Tcorpus6)
Tdtm
