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

## Exercise 1: Learn the calculate functions in spatialsampler

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

################################################################################

## Create a CSAS sampling grid of 100 sq kms on West Pokot
grid_100_csas <- create_sp_grid(x = westPokot,
                                area = 100,
                                country = "Kenya",
                                type = "csas")

## Create a S3M sampling grid of 100 sq kms on West Pokot
grid_100_s3m <- create_sp_grid(x = westPokot,
                               area = 100,
                               country = "Kenya",
                               type = "s3m")

