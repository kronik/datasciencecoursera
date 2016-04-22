library(dplyr)

#Set new working directory
setwd("~/work/datasciencecoursera/Exploratory Data Analysis/week4/")

NEI <- readRDS("summarySCC_PM25.rds")

s <- summarise(group_by(NEI, year), Emissions = sum(Emissions))

png("plot1.png", width=480, height=480)

barplot(height=s$Emissions, names.arg=s$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' emissions at various years'))

dev.off()