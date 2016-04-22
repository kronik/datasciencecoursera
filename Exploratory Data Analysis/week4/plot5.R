library(dplyr)
library(ggplot2)

#Set new working directory
setwd("~/work/datasciencecoursera/Exploratory Data Analysis/week4/")

NEI <- readRDS("summarySCC_PM25.rds")

baltimore <- NEI[NEI$fips == "24510" & NEI$type=="ON-ROAD",]
s <- summarise(group_by(baltimore, year), Emissions = sum(Emissions))

png("plot5.png", width=480, height=480)

g <- ggplot(s, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") + xlab("year") + ylab(expression('Total PM'[2.5]*" Emissions")) + ggtitle('Total Emissions from motor vehicle (type = ON-ROAD) in Baltimore City, Maryland (fips = "24510") from 1999 to 2008')
print(g)

dev.off()