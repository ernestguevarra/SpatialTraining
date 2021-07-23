## Read Sudan Shape file sudan01.shp (Create an object that contains sudan01)

library(rgeos)
library(rgdal)
library(raster)

sudan01 <- readOGR(dsn = "sudanMaps", layer = "sudan01")

coverage <- c(95, 56, 73, 55, 19, 97, 60, 2, 46, 31, 70, 23, 71, 66, 38, 78, 74, 51)

sudan01 <- cbind(sudan01, coverage = coverage)
names(sudan01)[ncol(sudan01)] <- "coverage"

sudan01@data

## Create a plot of the coverage values per State
plot(sudan01)

##choose the colour scheme 

library(RColorBrewer)

## Get RdYlGn colours using RColorBrewer
RdYlGn <- brewer.pal(n = 5, name = "RdYlGn")




