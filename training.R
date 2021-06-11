# Practice scripts for training on spatial

## Practice reading data - We practice using two functions - read.csv() and
## read.table() - to read a CSV file as follows:

sleacData <- read.csv(file = "westPokotSLEACdata.csv")

sleacDataX <- read.table(file = "westPokotSLEACdata.csv", header = TRUE, sep = ",")

## Practice reading map data - We practice using two functions - readShapeSpatial()
## and readOGR() - to read spatial data

install.packages(c("rgeos", "rgdal", "raster"))

library(rgeos)
library(rgdal)
library(raster)
#library(sf)

sudan01 <- readShapeSpatial(fn = "sudanMaps/sudan01")       ## Old approach; not recommended

sudan01 <- readOGR(dsn = "sudanMaps", layer = "sudan01")

sudan02 <- readOGR(dsn = "sudanMaps", layer = "sudan02")

## ESRI Shapefiles
## Read West Pokot Shapefiles into R as a SpatialPolygonsDataFrame
westPokot <- readOGR(dsn = "westPokotMaps", layer = "westPokot")

## View the data structure of an R object
str(westPokot)

## View the data.frame component of westPokot
westPokot@data

## View the SpatialPolygons componet of westPokot
westPokot@polygons

## Manipulation and plotting of spatial objects

## Plot westPokot
plot(westPokot)

## Access and plot the top county layer only

## Check what identifier is there for the polygon of interest
plot(westPokot)
text(x = coordinates(westPokot), labels = westPokot$SP_ID)
text(x = coordinates(westPokot),  labels = westPokot$NAME_4)

## Subset westPokot to only the polygon with SP_ID 1032
westPokot_1032 <- subset(x = westPokot, subset = SP_ID == 1032)
str(westPokot_1032)
plot(westPokot_1032)

## Plot 1032 in the centre with all other county borders still showing
plot(westPokot_1032, lty = 0)
plot(westPokot, add = TRUE)

## Plot westPokot with area 1032 with thicker borders and red colour
plot(westPokot)
plot(westPokot_1032, border = "red", lwd = 2, add = TRUE)

## Plot westPokot with area 1032 with line width of 5 and blue colour
plot(westPokot)
plot(westPokot_1032, border = "blue", lwd = 5, add = TRUE)

## Plot westPokot with area 1032 with line width of 3, border colour red, 
## and fill colour blue (col)
plot(westPokot_1032)

## Plot the SLEAC data by colouring the westPokot map based on their coverage
## results (choropleth map)

## First step: Calculate pt coverage for each sub-county
sam_pt_coverage <- sleacData$sam.in / sleacData$sam.total
sam_pt_coverage <- with(sleacData, sam.in / sam.total)

sam_pd_coverage <- 
sam_pd_coverage <- 

## How do I add the calculated coverage values to the sleacData object?
sleacData$sam_pt_coverage <- 
sleacData$sam_pd_coverage <- 
  
## Second step: Match the coverage values to the westPokot map

plot(westPokot)
text(x = coordinates(westPokot), labels = westPokot$SP_ID)
## We know already that 1032 matches with North Pokot
## 1037 = West Pokot
## 1036 = Central Pokot
## 1043 = South Pokot

westPokot@data$sub_county <- c("West Pokot", "Central Pokot", 
                               "South Pokot", "North Pokot")
westPokot@data$sub_county <- ifelse(westPokot@data$SP_ID == "1037", "West Pokot",
                               ifelse(westPokot@data$SP_ID == "1036", "Central Pokot",
                                 ifelse(westPokot@data$SP_ID == "1043", "South Pokot", "North Pokot")))

## merge sleadData with westPokot data
westPokot@data <- merge(x = westPokot@data, y = sleacData, 
                        by.x = "sub_county", by.y = "subcounty")



### Plot sudan01
plot(sudan01)

### Plot sudan01 with each state having a different colour (qualitative colours)

### Load library RColorBrewer
library(RColorBrewer)

### Create 9 colour qualitative palette using RColorBrewer
baseColours <- brewer.pal(n = 9, name = "Pastel1")

### Using sudanColours, create 18 unique colours using colorRampPalette function;
### Creates a function that can be used to create 18 colours
sudanColours <- colorRampPalette(colors = baseColours, space = "Lab")

plot(sudan01, col = sudanColours(n = 18))

### Plot state map and add label of states on map
plot(sudan01, col = sudanColours(n = 18))
text(x = coordinates(sudan01), labels = sudan01$State_En, cex = 0.5)

### Plot a red dot on Norht Kourfodan
plot(sudan01, col = sudanColours(n = 18))
points(coordinates(subset(sudan01, State_En == "North Kordofan")), pch = 19, col = "red", cex = 1)
text(x = coordinates(sudan01), labels = sudan01$State_En, cex = 0.5)

### 

### Plot villages on map


