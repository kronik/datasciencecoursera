best <- function(state, outcome) {
    ## Read outcome data
    data <- read.csv("~/work/datasciencecoursera/RLang/week4/data/outcome-of-care-measures.csv", na.strings="Not Available")
    
    ## Check that state and outcome are valid
    if (!(state %in% data[, 7])) {
        stop("invalid state")
    }
    
    data <- data[data$State == state,]
    
    dataBestValues <- numeric(nrow(data))
    
    if (outcome == "heart attack") {
        dataBestValues <- data[, 11]
    } else if (outcome == "heart failure") {
        dataBestValues <- data[, 17]
    } else if (outcome == "pneumonia") {
        dataBestValues <- data[, 23]
    } else {
        stop("invalid outcome")
    }
            
    data$bestValue <- dataBestValues
    
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    validData <- data[complete.cases(data$bestValue),]
    
    bestHospitals <- validData[which.min(validData$bestValue),]
    
    order.names <- order(bestHospitals[,2])
    
    bestHospitals <- bestHospitals[order.names,]
    
    bestHospitals[1,2]
}