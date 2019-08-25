# Practice scripts for training on spatial

## Practice reading data

sleacData <- read.csv(file = "westPokotSLEACdata.csv")

sleacDataX <- read.table(file = "westPokotSLEACdata.csv", header = TRUE, sep = ",")

library(rgeos)
library(rgdal)
library(maptools)



sudan01 <- readShapeSpatial(fn = "sudanMaps/sudan01")

sudan01 <- readOGR(dsn = "sudanMaps", layer = "sudan01")

sudan02 <- readOGR(dsn = "sudanMaps", layer = "sudan02")

library(RColorBrewer)

baseColours

plot(sudan01)

plot(sudan01, col =)



