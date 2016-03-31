library(dplyr)

loadData <- function() {
    #Read only first 69516 rows and cover 02/02/2007 to speed up reading 
    df <- read.table("household_power_consumption.txt", sep=";", na.strings = "?", header=TRUE, colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), nrows = 69516)
    
    #Filter out February 1 and February 2 2007 
    df <- df[df$Date == '1/2/2007' | df$Date == '2/2/2007',]
    
    df <- mutate(df, DateTime = paste(Date, Time))
    
    df$DateTime <- strptime(df$DateTime,"%d/%m/%Y %H:%M:%S")
    
    df
}

drawPlot <- function() {
    df <- loadData()

    png("plot4.png", width=480, height=480)
    
    par(mfrow=c(2, 2))
    
    #draw first plot
    plot(df$DateTime, df$Global_active_power, typ='l', ann=F, lwd=1)
    title(ylab="Global Active Power")
    
    #draw second plot
    plot(df$DateTime, df$Voltage, typ='l', ann=F, lwd=1)
    title(xlab="datetime", ylab="Voltage")
    
    #draw third plot
    plot(df$DateTime, df$Sub_metering_1, typ='l', ann=F, col="black")
    points(df$DateTime, df$Sub_metering_2, col="red", typ="l")
    points(df$DateTime, df$Sub_metering_3, col="blue", typ="l")
    
    title(ylab="Energy sub metering")    
    
    legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1, 1), lwd = c(1.5, 1.5, 1.5), col=c("black", "red", "blue"), bty = "n")
    
    #draw forth plot
    plot(df$DateTime, df$Global_reactive_power, typ='l', ann=F, lwd=1)
    title(xlab="datetime", ylab="Global_reactive_power")
    
    dev.off()
}