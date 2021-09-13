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
westPokot <- readOGR(dsn = "westPokotMaps", layer = "westPokot")


## Exercise 1: Learn the calculate functions in spatialsampler -----------------

## Calculate area size of hexagonal grid for a d value of 10km
area_size <- calculate_area(d = 10)
tri_area_size <- area_size$tri
hex_area_size <- area_size$hex

## Calculate the number of sampling points on West Pokot when a grid of 
## d = 10 kms is used
##
## Solution: Calculate area size of West Pokot and then divide by area size of
## hexagon (hex_area_sizse)
westPokotArea <- raster::area(x = westPokot)
westPokotArea <- sum(westPokotArea)
westPokotArea <- westPokotArea / 1000000

n_sampling_points <- westPokotArea / hex_area_size

## Calculate the value of d for a hexagon grid size of 100 sq kms
d_100_hex <- calculate_d(area = 100, geom = "hex")
d_100_tri <- calculate_d(area = 100, geom = "tri")

## Calculate the area size for d = 6.204032
calculate_area(d = d_100_hex)

## Calculate the length of the rectangular grid for a d = d_100_hex
grid_length <- calculate_length(d = d_100_hex)
grid_height <- calculate_height(d = d_100_hex)

## Use calculate_n to calculate number of grids (sampling points) for d = 10 kms
## for West Pokot
n_grids <- calculate_n(x = westPokot, d = 10, country = "Kenya")


## Sampling Functions ----------------------------------------------------------

## Create a grid - use create_sp_grid function using either a d value or a
## a grid size area value

## Create a CSAS sampling grid of 100 sq kms on West Pokot
sp_100_csas <- create_sp_grid(x = westPokot,
                              area = 100,
                              country = "Kenya",
                              type = "csas")

## Create a SpatialPixels object showing the square grids of the CSAS sample
grid_100_csas <- SpatialPixels(sp_100_csas)

## Plot the map of West Pokot with the CSAS sample
plot(westPokot, lwd = 2)
plot(grid_100_csas, col = "blue", lwd = 1, add = TRUE)
plot(sp_100_csas, col = "red", add = TRUE)

## Create a S3M sampling grid of 100 sq kms on West Pokot
sp_100_s3m <- create_sp_grid(x = westPokot,
                             area = 100,
                             country = "Kenya",
                             type = "s3m")

## Create a SpatialPolygons object showing the hexagonal grid for the S3M sample
grid_100_s3m <- HexPoints2SpatialPolygons(sp_100_s3m)

## Plot the map of West Pokot with the S3M sample
plot(westPokot, lwd = 2)
plot(grid_100_s3m, border = "blue", lwd = 1, add = TRUE)
plot(sp_100_s3m, col = "red", pch = 20, add = TRUE)

## Move the sampling points to the location of the villages nearby

village_locations <- readOGR(dsn = "KEN_Populated places_2002_DEPHA",
                             layer = "KEN_Populated places_2002_DEPHA")

## subset village_locations to those that are only in West Pokot
westPokot_village_locations <- village_locations[westPokot, ]

## Select the nearest 1 village to the sampling points
sp_villages_100_s3m <- get_nearest_point(
  data = westPokot_village_locations@data, 
  data.x = "NEWDLONG", data.y = "NEWDLAT",
  query = sp_100_s3m
)

