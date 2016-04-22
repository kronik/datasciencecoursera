library(dplyr)
library(ggplot2)

#Set new working directory
setwd("~/work/datasciencecoursera/Exploratory Data Analysis/week4/")

NEI <- readRDS("summarySCC_PM25.rds")

baltimore <- NEI[NEI$fips == "24510",]
s <- summarise(group_by(baltimore, year), Emissions = sum(Emissions))

png("plot2.png", width=480, height=480)

barplot(height=s$Emissions, names.arg=s$year, xlab="years", ylab=expression('total PM'[2.5]*' emission'),main=expression('Total PM'[2.5]*' in the Baltimore City, MD emissions at various years'))

dev.off()