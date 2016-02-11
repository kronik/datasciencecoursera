library(stringr)

complete <- function(directory, id=1:332) {
    nobs <- numeric()
    
    for (index in id) {
        path <- file.path(directory, paste(str_pad(index, 3, pad="0"), ".csv", sep=""))
        dataFrame <- read.csv(path)

        nonNan <- dataFrame[complete.cases(dataFrame$sulfate) & complete.cases(dataFrame$nitrate),]

        nobs <- c(nobs, nrow(nonNan))
    }

    data.frame(id, nobs)
}