library(dplyr)
library(plyr)
library(mice)
library(Hmisc)

setwd("~/work/datasciencecoursera/Reproducible Research/week4/")

data <- read.csv("repdata-data-StormData.csv.bz2")
names(data)
anyNA(data)

filteredData <- data[,c("EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "CROPDMG")]
anyNA(filteredData)

data <- mutate(filteredData, populationAffected = FATALITIES + INJURIES, economicEvents = PROPDMG + CROPDMG) 
nrow(data[data$FATALITIES > 0 & data$INJURIES > 0, ])

groupByPopulation <- aggregate(populationAffected ~ EVTYPE, data, sum)
groupByPopulation <- groupByPopulation[groupByPopulation$populationAffected > 0,]
sortedByPopulation <- arrange(groupByPopulation, desc(populationAffected))
top10ByPopulation <- head(sortedByPopulation, n=10)
barplot(height=top10ByPopulation$populationAffected, names.arg=top10ByPopulation$EVTYPE, ylab="Population affected",main="Top 10 the most harmful events")

groupByEconomicEvent <- aggregate(economicEvents ~ EVTYPE, data, sum)
groupByEconomicEvent <- groupByEconomicEvent[groupByEconomicEvent$economicEvents > 0,]
sortedByEconomicEvent <- arrange(groupByEconomicEvent, desc(economicEvents))
top10ByEconomicEvent <- head(sortedByEconomicEvent, n=10)
barplot(height=top10ByEconomicEvent$economicEvents, names.arg=top10ByEconomicEvent$EVTYPE, ylab="Economic consequences costs",main="Top 10 the most harmful events")



