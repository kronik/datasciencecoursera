rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    data <- read.csv("~/work/datasciencecoursera/RLang/week4/data/outcome-of-care-measures.csv", na.strings="Not Available")
    
    ## Check that state is valid
    if (!(state %in% data[, 7])) {
        stop("invalid state")
    }
    
    ## Check that outcome is valid
    data <- data[data$State == state,]
    
    ## Check that outcome is valid
    if (outcome == "heart attack") {
        data <- data[, c(2, 7, 11)]
    } else if (outcome == "heart failure") {
        data <- data[, c(2, 7, 17)]
    } else if (outcome == "pneumonia") {
        data <- data[, c(2, 7, 23)]
    } else {
        stop("invalid outcome")
    }
    
    names(data) <- c("hospital", "state", "outcome")
    
    validData <- data[complete.cases(data$outcome),]
    
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    
    index <- with(validData, order(outcome, hospital))
    data <- validData[index,]
    
    if (num == "worst") {
        groupIndex <- nrow(data)
    } else if (num == "best") {
        groupIndex <- 1
    } else {
        groupIndex <- num
    }

    data[groupIndex, 1]

}