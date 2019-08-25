createMapPalette <- colorRampPalette(colors = c("#C7E9C0", "#A1D99B", "#74C476", "#41AB5D", "#238B45", "#005A32"), space = "Lab")
mapPalette <- createMapPalette(18)

plot(sudan01, lty = 0)

for(i in 1:length(sudan01@polygons))
  {
  polygon(sudan01@polygons[[i]]@Polygons[[1]]@coords, col = mapPalette[i])
  }


states   <- as.vector(sudan01@data$State)
coverage <- c(95, 56, 73, 55, 19, 97, 60, 2, 46, 31, 70, 23, 71, 66, 38, 78, 74, 51)

#coverage <- sample(0:100, 18, replace = TRUE)

exData        <- data.frame(states, coverage)
names(exData) <- c("states", "coverage") 

createMapPalette <- colorRampPalette(colors = c("white", "lightgreen", "green", "darkgreen"), space = "Lab")
mapPalette <- createMapPalette(101)

plot(sudan01, col = mapPalette[exData$coverage])

plot(sudan01, lty = 0)

for(i in 1:length(sudan01@polygons))
  {
  polygon(sudan01@polygons[[i]]@Polygons[[1]]@coords, col = mapPalette[exData$coverage[i]])
  }

sudan01@polygons[[8]]


plot(sudan01, lty = 0, col = mapPalette[exData$coverage])
plot(sudan02, lwd = 0.5, lty = 3, border = "gray", add = TRUE)
plot(sudan01, lwd = 1, add = TRUE)
text(coordinates(sudan01)[,1], coordinates(sudan01)[,2], labels = sudan01@data$State, pos = 3, offset = 0.2, cex = 0.5)


createMapPalette <- colorRampPalette(colors = c("white", "lightgreen", "green", "darkgreen"), space = "Lab")
mapPalette <- createMapPalette(101)

