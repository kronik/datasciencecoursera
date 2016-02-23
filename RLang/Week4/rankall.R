rankall <- function(outcome, num = "best") {
    ## Read outcome data
    data <- read.csv("~/work/datasciencecoursera/RLang/week4/data/outcome-of-care-measures.csv", na.strings="Not Available")
    
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
    
    ## For each state, find the hospital of the given rank
    index <- with(validData, order(state, outcome, hospital))
    data <- validData[index,]

    groups <- split(data, data$state)
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    ranks <- sapply(groups, function(group) {
        if (num == "worst") {
            group[nrow(group), 1]
        } else if (num == "best") {
            group[1, 1]
        } else {
            group[num, 1]
        }
    })
    
    states <- names(ranks)

    resultDataFrame <- data.frame(hospital=ranks, state=states, row.names=states)
}