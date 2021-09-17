################################################################################
#
# Notes on training on how to use the spatialsampler package
#
################################################################################

## Load spatialsampler package
library(spatialsampler)
library(rgdal)
library(raster)

## Load a map for the exercises
sudan01 <- readOGR(dsn = "sudanMaps", layer = "sudan01")


## Exercise 1: Learn the calculate functions in spatialsampler -----------------

## Calculate area size of hexagonal grid for a d value of 10km
area_size <- calculate_area(d = 10)
tri_area_size <- area_size$tri
hex_area_size <- area_size$hex

## Calculate the number of sampling points on West Pokot when a grid of 
## d = 10 kms is used
##
## Solution: Calculate area size of West Pokot and then divide by area size of
## hexagon (hex_area_size)
sudan01Area <- raster::area(x = sudan01)
sudan01Area <- sum(sudan01Area)
sudan01Area <- sudan01Area / 1000000

n_sampling_points <- sudan01Area / hex_area_size

n## Calculate the value of d for a hexagon grid size of 100 sq kms

d_sudan01_hex <- calculate_d(area = sudan01Area/2000, geom = "hex")
d_sudan01_tri <- calculate_d(area = sudan01Area/2000, geom = "tri")

## Calculate the area size for d = 6.204032
calculate_area(d = d_sudan01_hex)

## Calculate the length of the rectangular grid for a d = d_100_hex
grid_length <- calculate_length(d = d_sudan01_hex)
grid_height <- calculate_height(d = d_sudan01_hex)

## Use calculate_n to calculate number of grids (sampling points) for d = 10 kms
## for West Pokot
n_grids <- calculate_n(x = sudan01, d = sudan01Area/2000, country = "Sudan")


## Sampling Functions ----------------------------------------------------------

## Create a grid - use create_sp_grid function using either a d value or a
## a grid size area value

## Create a CSAS sampling grid of 100 sq kms on West Pokot
sp_100_csas <- create_sp_grid(x = sudan01,
                              area = sudan01/2000,
                              country = "Sudan",
                              type = "csas")

## Create a SpatialPixels object showing the square grids of the CSAS sample
grid_sudan01_csas <- SpatialPixels(sp_sudan01_csas)

## Plot the map of West Pokot with the CSAS sample
plot(sudan01, lwd = 2)
plot(grid_sudan01_csas, col = "blue", lwd = 1, add = TRUE)
plot(sp_sudan01_csas, col = "red", add = TRUE)

## Create a S3M sampling grid of sudan01
sp_sudan01_s3m <- create_sp_grid(x = sudan01,
                             area = sudan01Area/2000,
                             country = "Sudan",
                             type = "s3m")

## Create a SpatialPolygons object showing the hexagonal grid for the S3M sample
grid_sudan01_s3m <- HexPoints2SpatialPolygons(sp_sudan01_s3m)

## Plot the map of Sudan with the S3M sample
plot(sudan01, lwd = 2)
plot(grid_sudan01_s3m, border = "blue", lwd = 1, add = TRUE)
plot(sp_sudan01__s3m, col = "red", pch = 20, add = TRUE)

## Move the sampling points to the location of the villages nearby

village_locations <- readOGR(dsn = "sudanMaps",
                             layer = "sudan01")

## subset village_locations to those that are only in_________
sudan01_village_locations <- village_locations[sudan01, ]

## Select the nearest 1 village to the sampling points
##sp_villages_sudan01_s3m <- get_nearest_point(
  ## data = sudan01_village_locations@data, 
  ## = "LONG", data.y = "LAT",
  ##query = sp_sudan01_s3m
#)

