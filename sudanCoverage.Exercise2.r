## Read coverage.csv file 

library(rgeos)
library(rgdal)
library(raster)

coverage <- read.csv(file = "coverage.csv")
coverage <- read.table(file = "coverage.csv", header = TRUE, sep = ",")

sudan01 <- readOGR(dsn = "sudanMaps", layer = "sudan01")

## Combine the coverage values in coverage.csv with sudan01

sudan01 <- cbind(sudan01, coverage.csv = coverage.csv)
names(sudan01)[ncol(sudan01)] <- "coverage"

## view the structure of the data
str(sudan01)

## View the Spatial data.frame component of the sudan01 object
sudan01@data

## View the SpatialPolygons component of sudan01 object
sudan01@polygons

## Plot sudan01
plot(sudan01)

# Create a choropleth map - map a specific numeric value from data associated
## with the regions within an area


## in this exercise 5 classes: 0, 0.25, 0.5, 0.75, 1 are used

## colours to be used are based on the above scale and groupings
## For 5 groupings, we need 5 colours and we will use a divergent colour
## scheme using the Red-Yellow-Green (RdYlGn) colour scheme

### Load library RColorBrewer
#install.packages("RColorBrewer")

sudan01@data

## Create a plot of the coverage values per State
plot(sudan01)

##choose the colour scheme 

library(RColorBrewer)

## Get RdYlGn colours using RColorBrewer
RdYlGn <- brewer.pal(n = 5, name = "RdYlGn")

## Classify coverage values using the cut function and command
coverage_class <- cut(x = sudan01@data$coverage,
                      breaks = c(0, 25, 50, 75, 100),
                      include.lowest = FALSE, right = TRUE, label = FALSE) + 1
coverage_class <- ifelse(is.na(coverage_class), 1, coverage_class)

## Plot the coverage choropleth map
## 
plot(sudan01,
     col = RdYlGn[coverage_class], 
     border = "gray50", lwd = 2)
text(coordinates(sudan01), labels = sudan01@data$State_En, cex = 0.8)

## Add a legend

legend(
  title = "Coverage Map",
  x = "topright", inset = 0.002,
  legend = c("0%", "> 0 and <= 20%", "> 20% and <= 40", 
             "> 40% and <= 60%", ">60% and <= 80%", "> 80% and <= 100%"),
  pch = 22, pt.cex = 2,
  col = RdYlGn, pt.bg = RdYlGn,
  bty = "n", cex = 0.75
)

## Mapping classifications rather than numbers
RdYlGn <- brewer.pal(n = 3, name = "RdYlGn")

coverage_class <- cut(x = sudan01@data$coverage,
                      breaks = c(0, 30, 70, 100),
                      
                      include.lowest = TRUE, right = FALSE, label = c("low", "moderate", "high"))
sudan01 <- cbind(sudan01, coverage_class = coverage_class)

names(sudan01)[ncol(sudan01)] <- "coverage_class"
plot(sudan01,
     col = ifelse(sudan01@data$coverage_class == "low", RdYlGn[1],
                  ifelse(sudan01@data$coverage_class == "moderate", RdYlGn[2], RdYlGn[3])), 
     border = "gray50", lwd = 3)

text(coordinates(sudan01), labels = sudan01@data$State_En)

## Add a map legend to the Vitamin A Coverage classification
legend(
  title = "Coverage Classification",
  x = "topright", inset = 0.002,
  legend = c("Low (0-30%)", "Moderate (30%-70%)", "High (70%-100%"),
  pch = 22, pt.cex = 2,
  col = RdYlGn, pt.bg = RdYlGn,
  bty = "n", cex = 0.75
)