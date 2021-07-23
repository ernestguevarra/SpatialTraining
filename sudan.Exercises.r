## Read Sudan Shape file sudan01.shp (Create an object that contains sudan01)

library(rgeos)
library(rgdal)
library(raster)

sudan01 <- readOGR(dsn = "sudanMaps", layer = "sudan01")

coverage <- c(95, 56, 73, 55, 19, 97, 60, 2, 46, 31, 70, 23, 71, 66, 38, 78, 74, 51)

sudan01 <- cbind(sudan01, coverage = coverage)
names(sudan01)[ncol(sudan01)] <- "coverage"

<<<<<<< HEAD
## Create a plot of the coverage values per State

## view the structure of the data
str(sudan01)

## View the Spatial data.frame component of the sudan01 object
sudan01@data

## View the SpatialPolygons component of sudan01 object
sudan01@polygons

## Plot sudan01
plot(sudan01)


## Create a choropleth map - map a specific numeric value from data associated
## with the regions within an area


## in this exercise 5 classes: 0, 0.25, 0.5, 0.75, 1 are used

## colours to be used are based on the above scale and groupings
## For 5 groupings, we need 5 colours and we will use a divergent colour
## scheme using the Red-Yellow-Green (RdYlGn) colour scheme

### Load library RColorBrewer
#install.packages("RColorBrewer")
=======
sudan01@data

## Create a plot of the coverage values per State
plot(sudan01)

##choose the colour scheme 
>>>>>>> d6c3583ef1d8b8dede05906e59aa8400d9814b31

library(RColorBrewer)

## Get RdYlGn colours using RColorBrewer
RdYlGn <- brewer.pal(n = 5, name = "RdYlGn")

<<<<<<< HEAD
## merge Coverage Data with Sudan map

sudan01 <- merge(x = sudan01, y = coverage, 
                   by.x = "State_En", by.y = "State_En")


## Classify coverage values using the cut function and command
coverage_class <- cut(x = sudan01@data$coverage,
                    breaks = c(0, 0.25, 0.5, 0.75, 1),
                    include.lowest = FALSE, right = TRUE, label = FALSE) + 1
coverage_class <- ifelse(is.na(coverage_class), 1, coverage_class)

## Plot the coverage choropleth map
## 
plot(sudan01,
     col = RdYlGn[coverage_class], 
     border = "gray50", lwd = 2)
text(coordinates(sudan01), labels = sudan01@data$State_En)

## Add a legend

legend(
  title = "Viatamin A Coverage",
  x = "topright", inset = 0.002,
  legend = c("0%", "> 0 and <= 20%", "> 20% and <= 40", 
             "> 40% and <= 60%", ">60% and <= 80%", "> 80% and <= 100%"),
  pch = 22, pt.cex = 2,
  col = RdYlGn, pt.bg = RdYlGn,
  bty = "n", cex = 0.75
)

## Mapping classifications rather than numbers
RdYlGn <- brewer.pal(n = 3, name = "RdYlGn")

plot(westPokot,
     col = ifelse(sudan01t@data$coverage_class == "low", RdYlGn[1],
                  ifelse(sudan01@data$coverage_class == "moderate", RdYlGn[2], RdYlGn[3])), 
     border = "gray50", lwd = 3)
text(coordinates(sudan01), labels = sudan01@data$State_En)

## Add a map legend to the Vitamin A Coverage classification
legend(
  title = "Vitamin Coverage Classification",
  x = "topright", inset = 0.002,
  legend = c("Low (0-20%)", "Moderate (20%-50%)", "High (50%-100%"),
  pch = 22, pt.cex = 2,
  col = RdYlGn, pt.bg = RdYlGn,
  bty = "n", cex = 0.75
)
=======

>>>>>>> d6c3583ef1d8b8dede05906e59aa8400d9814b31


