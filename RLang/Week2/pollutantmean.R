library(stringr)

pollutantmean <- function(directory, pollutant, id=1:332) {
    meanData <- double()
    
    for (index in id) {
        path <- file.path(directory, paste(str_pad(index, 3, pad="0"), ".csv", sep=""))
        dataFrame <- read.csv(path)
        meanData <- c(meanData, dataFrame[[pollutant]])
    }
    
    mean(meanData, na.rm=TRUE)
}