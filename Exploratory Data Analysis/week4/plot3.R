library(dplyr)
library(ggplot2)

#Set new working directory
setwd("~/work/datasciencecoursera/Exploratory Data Analysis/week4/")

NEI <- readRDS("summarySCC_PM25.rds")

baltimore <- NEI[NEI$fips == "24510",]
s <- summarise(group_by(baltimore, type, year), Emissions = sum(Emissions))

png("plot3.png", width=480, height=480)

g <- ggplot(s, aes(year, Emissions, color = type))
g <- g + geom_line() + xlab("year") + ylab(expression('Total PM'[2.5]*" Emissions")) + ggtitle('Total Emissions in Baltimore City, Maryland (fips == "24510") from 1999 to 2008')
print(g)

dev.off()
