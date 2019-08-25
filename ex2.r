xAll <- NULL; yAll <- NULL

for(i in 1:length(sudan01@polygons))
  {
  xCentroid   <- mean(min(sudan01@polygons[[i]]@Polygons[[1]]@coords[,1]), 
                      max(sudan01@polygons[[i]]@Polygons[[1]]@coords[,1]))
  yCentroid   <- mean(min(sudan01@polygons[[i]]@Polygons[[1]]@coords[,2]),
                      max(sudan01@polygons[[i]]@Polygons[[1]]@coords[,2]))
  xAll        <- c(xAll, xCentroid)
  yAll        <- c(yAll, yCentroid)
  xyCentroid  <- cbind(xAll, yAll)
  }


xAll <- NULL; yAll <- NULL

for(i in 1:length(sudan01@polygons))
  {
  xState         <- sudan01@polygons[[i]]@Polygons[[1]]@coords[,1]
  yState         <- sudan01@polygons[[i]]@Polygons[[1]]@coords[,2]
  stateLimits    <- bbox(polygons(xState, yState))
  xStateLimits   <- mean(stateLimits[1,])
  yStateLimits   <- mean(stateLimits[2,])
  xAll           <- c(xAll, xStateLimits)
  yAll           <- c(yAll, yStateLimits)
  xyCentroid     <- cbind(xAll, yAll)
  }




sudan01Centroids <- coordinates(sudan01)

plot(sudan01)
text(sudan01Centroids[,1], sudan01Centroids[,2], labels = sudan01@data$State, pos = 3, offset = 0.2, cex = 0.5)


