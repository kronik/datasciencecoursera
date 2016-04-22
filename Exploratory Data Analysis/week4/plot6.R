library(dplyr)
library(ggplot2)

#Set new working directory
setwd("~/work/datasciencecoursera/Exploratory Data Analysis/week4/")

NEI <- readRDS("summarySCC_PM25.rds")

cities <- NEI[(NEI$fips == "06037" | NEI$fips == "24510") & NEI$type=="ON-ROAD",]
s <- summarise(group_by(cities, fips, year), Emissions = sum(Emissions))

png("plot6.png", width=480, height=480)

g <- ggplot(s, aes(factor(year), Emissions))
g <- g + facet_grid(. ~ fips)
g <- g + geom_bar(stat="identity") + xlab("year") + ylab(expression('Total PM'[2.5]*" Emissions")) + ggtitle('Total Emissions from motor vehicle (type=ON-ROAD) in Baltimore City, MD (fips = "24510") vs Los Angeles, CA (fips = "06037")  1999-2008')

print(g)

dev.off()
