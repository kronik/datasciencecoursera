library(dplyr)

loadData <- function() {
    #Read only first 69516 rows and cover 02/02/2007 to speed up reading 
    df <- read.table("household_power_consumption.txt", sep=";", na.strings = "?", header=TRUE, colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), nrows = 69516)
    
    #Filter out February 1 and February 2 2007 
    df <- df[df$Date == '1/2/2007' | df$Date == '2/2/2007',]

    df
}

drawPlot <- function() {
    df <- loadData()

    png("plot1.png", width=480, height=480)
    
    par(mfrow=c(1, 1))
    hist(df$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency")

    dev.off()
}