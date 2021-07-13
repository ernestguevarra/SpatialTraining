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

mam_pt_coverage <- sleacData$mam.in / sleacData$mam.total
mam_pt_coverage <- with(sleacData, mam.in /mam.total)

sam_pd_coverage <- with(sleacData, (sam.in + sam.rec) / (sam.total + sam.rec))
mam_pd_coverage <- with(sleacData, (mam.in + mam.rec) / (mam.total + mam.rec))

## How do I add the calculated coverage values to the sleacData object?
sleacData$sam_pt_coverage <- sam_pt_coverage
sleacData$sam_pd_coverage <- sam_pd_coverage
  
## Second step: Match the coverage values to the westPokot map

plot(westPokot)
text(x = coordinates(westPokot), labels = westPokot$SP_ID)
## We know already that 1032 matches with North Pokot
## 1032 = North Pokot
## 1036 = Central Pokot
## 1043 = South Pokot

westPokot@data$sub_county <- ifelse(westPokot@data$SP_ID == "1032", "North Pokot",
                               ifelse(westPokot@data$SP_ID == "1036", "Central Pokot",
                                 ifelse(westPokot@data$SP_ID == "1043", "South Pokot", "West Pokot")))

## merge sleadData with westPokot map
westPokot <- merge(x = westPokot, y = sleacData, 
                   by.x = "sub_county", by.y = "subcounty")

## Plot a SAM coverage map (point and period) for West Pokot County
## Create a choropleth map - map a specific numeric value from data associated
## with the regions within an area

## Step 1: Colours - specify a scale and groupings
## For proportion values such as coverage indicators, the natural scale is from
## 0-1 (or 1 - 100 if converted to percentages)
##
## 11 groupings - 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 - 11 colours
## 6 groupings - 0, 0.2, 0.4, 0.6, 0.8, 1 - 6 colours
## 3 groupings - 0, 0.5, 1 - 3 colours
## 5 groupings - 0, 0.25, 0.5, 0.75, 1 - 5 colours
## https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
##
## Slocum et al. (2008) Thematic Cartography and Visualization. Pentice Hall
##
## ColorBrewer: An online tool for selecting color schemes for maps. The 
## Cartographic Journal 40(1): 27-37.
##
## For this example, we will use 6 classes
##

## Step 2: Get colours based on your chosen scale and groupings
## For 6 groupings, we need 6 colours and we will use a divergent colour
## scheme using the Red-Yellow-Green (RdYlGn) colour scheme
##
RdYlGn <- c("#d73027", "#fc8d59", "#fee08b", "#d9ef8b", "#91cf60", "#1a9850")

### Load library RColorBrewer
#install.packages("RColorBrewer")
library(RColorBrewer)

## Get RdYlGn colours using RColorBrewer
RdYlGn <- brewer.pal(n = 6, name = "RdYlGn")

## Step 3: Classify the coverage data based on the colour scale groupings

## Use ifelse to classify point coverage values
sam_pt_class <- with(westPokot@data, 
  ifelse(sam_pt_coverage == 0, 1,
    ifelse(sam_pt_coverage > 0 & sam_pt_coverage <= 0.2, 2,
      ifelse(sam_pt_coverage > 0.2 & sam_pt_coverage <= 0.4, 3,
        ifelse(sam_pt_coverage > 0.4 & sam_pt_coverage <= 0.6, 4,
          ifelse(sam_pt_coverage > 0.6 & sam_pt_coverage <= 0.8, 5, 6)))))
)

## Use cut to classify point coverage values
sam_pt_class <- cut(x = westPokot@data$sam_pt_coverage,
                    breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
                    include.lowest = FALSE, right = TRUE, label = FALSE) + 1
sam_pt_class <- ifelse(is.na(sam_pt_class), 1, sam_pt_class)



## Step 4: Plot the point coverage choropleth map
## This plot will produce wrong colours for the coverage values of each subcounty
plot(westPokot,
     col = RdYlGn[sam_pt_class], 
     border = "gray50", lwd = 3)
text(coordinates(westPokot), labels = westPokot@data$sub_county)


## Step 5: add a legend
## This step is to learn how to add a map legend











