library(stringr)
source("complete.R")

corr <- function(directory, threshold = 0) {
    completeCases <- complete(directory)
    id <- numeric()
    correlations <- double()
    
    completeCases <- completeCases[completeCases$nobs > threshold,]
    id <- completeCases$id
    
    for (index in id) {
        path <- file.path(directory, paste(str_pad(index, 3, pad="0"), ".csv", sep=""))
        dataFrame <- read.csv(path)
        
        nonNan <- dataFrame[complete.cases(dataFrame$sulfate) & complete.cases(dataFrame$nitrate),]
        
        correlations <- c(correlations, cor(nonNan$sulfate, nonNan$nitrate))
    }
    
    correlations
}

testCorr <- function(directory, threshold = 0) {
    cr <- corr(directory, threshold)
    
    print(head(cr))
    print(summary(cr))
    print(length(cr))
}
