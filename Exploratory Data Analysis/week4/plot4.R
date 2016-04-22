library(dplyr)
library(ggplot2)

#Set new working directory
setwd("~/work/datasciencecoursera/Exploratory Data Analysis/week4/")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

coal <- SCC[grepl("coal.*combustion", tolower(SCC$Short.Name)),]
us <- merge(NEI, coal, by="SCC", all.x=FALSE, all.y=TRUE, sort=FALSE)
s <- summarise(group_by(us, Short.Name, year), Emissions = sum(Emissions))

png("plot4.png", width=480, height=480)

g <- ggplot(s, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") + xlab("year") + ylab(expression('Total PM'[2.5]*" Emissions")) + ggtitle('Total Emissions from coal sources from 1999 to 2008')
print(g)

dev.off()