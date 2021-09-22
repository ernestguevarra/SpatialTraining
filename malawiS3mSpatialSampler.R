################################################################################
#
# Exercise on sub-setting Malawi map to central region and Dowa district 
#
################################################################################

install.packages(c("rgeos", "rgdal", "raster"))

library(rgeos)
library(rgdal)
library(raster)
library(spatialsampler)

## Load a map for the exercises
mwi_admbnda_adm0_nso_20181016 <- readOGR(dsn = "mwi_adm_nso_20181016_shp", layer = "mwi_admbnda_adm0_nso_20181016")
mwi_admbnda_adm1_nso_20181016 <- readOGR(dsn = "mwi_adm_nso_20181016_shp", layer = "mwi_admbnda_adm1_nso_20181016")
mwi_admbnda_adm2_nso_20181016 <- readOGR(dsn = "mwi_adm_nso_20181016_shp", layer = "mwi_admbnda_adm2_nso_20181016")
mwi_admbnda_adm3_nso_20181016 <- readOGR(dsn = "mwi_adm_nso_20181016_shp", layer = "mwi_admbnda_adm3_nso_20181016")

## Access and plot the central region layer only

## Check what identifier is there for the polygon of interest

plot(mwi_admbnda_adm1_nso_20181016)
text(x = coordinates(mwi_admbnda_adm1_nso_20181016), labels = mwi_admbnda_adm1_nso_20181016$ADM1_PCODE)
text(x = coordinates(mwi_admbnda_adm1_nso_20181016), labels = mwi_admbnda_adm1_nso_20181016$ADM1_EN)

### check identifier for regions and districts layers
plot(mwi_admbnda_adm2_nso_20181016)
text(x = coordinates(mwi_admbnda_adm2_nso_20181016), labels = mwi_admbnda_adm2_nso_20181016$ADM2_PCODE)
text(x = coordinates(mwi_admbnda_adm2_nso_20181016), labels = mwi_admbnda_adm2_nso_20181016$ADM2_EN)

## Subset Central region only the polygon with MW2
CentralRegion_MW2 <- subset(x = mwi_admbnda_adm1_nso_20181016, subset = ADM1_PCODE == MW2)
str(CentralRegion_MW2)
plot(CentralRegion_MW2)

## Subset Dowa district only the polygon with identifier MW204

DowaDistrict_MW204 <- subset(x = mwi_admbnda_adm2_nso_20181016, subset = ADM2_PCODE == MW204)
str(DowaDistrict_MW204)
plot(DowaDistrict_MW204)

## Plot Dowa_MW204 in the centre with all other districts borders still showing
plot(DowaDistrict_MW204, lty = 0)
plot(DowaDistrict_MW204, add = TRUE)

## Plot Dowa with area MW204 with thicker borders and red colour
plot(DowaDistrict_MW204)
plot(DowaDistrict_MW204, border = "red", lwd = 2, add = TRUE)

## Plot Dowa with area MW204 with line width of 5 and blue colour
plot(DowaDistrict_MW204)
plot(DowaDistrict_MW204, border = "blue", lwd = 5, add = TRUE)

####################################################################################################################
####################################################################################################################

## Exercise 1: Learn the calculate functions in spatial sampler -----------------

## Calculate area size of hexagonal grid for a d value of 10km
area_size <- calculate_area(d = 10)
tri_area_size <- area_size$tri
hex_area_size <- area_size$hex

## Calculate the number of sampling points Malawi when a grid of 
## d = 10 kms is used
##
## Solution: Calculate area size of Malawi and then divide by area size of
## hexagon (hex_area_size)
mwi_admbnda_adm3_nso_20181016Area <- raster::area(x = mwi_admbnda_adm3_nso_20181016)
mwi_admbnda_adm3_nso_20181016Area <- sum(mwi_admbnda_adm3_nso_20181016Area)
mwi_admbnda_adm3_nso_20181016Area <- mwi_admbnda_adm3_nso_20181016Area / 1000000

n_sampling_points <- mwi_admbnda_adm3_nso_20181016Area / hex_area_size

## Calculate the value of d for a hexagon grid size of 100 sq kms

d_mwi_admbnda_adm3_nso_20181016_hex <- calculate_d(area = mwi_admbnda_adm3_nso_20181016Area/100, geom = "hex")
d_mwi_admbnda_adm3_nso_20181016_tri <- calculate_d(area = mwi_admbnda_adm3_nso_20181016Area/100, geom = "tri")

## Calculate the area size for d = 6.204032
calculate_area(d = d_mwi_admbnda_adm3_nso_20181016_hex)

## Calculate the length of the rectangular grid for a d = d_100_hex
grid_length <- calculate_length(d = d_mwi_admbnda_adm3_nso_20181016_hex)
grid_height <- calculate_height(d = d_mwi_admbnda_adm3_nso_20181016_hex)

## Use calculate_n to calculate number of grids (sampling points) for d = 10 kms
n_grids <- calculate_n(x = d_mwi_admbnda_adm3_nso_20181016_hex, d = 10, country = "Malawi")

## Sampling Functions ----------------------------------------------------------

## Create a grid - use create_sp_grid function using either a d value or a
## a grid size area value

## Create a CSAS sampling grid of 100 sq kms on Dowa district
sp_100_csas <- create_sp_grid(x = mwi_admbnda_adm3_nso_20181016,
                              area = mwi_admbnda_adm3_nso_20181016/100,
                              country = "Malawi",
                              type = "csas")

## Create a SpatialPixels object showing the square grids of the CSAS sample
grid_mwi_admbnda_adm3_nso_20181016_csas <- SpatialPixels(sp_mwi_admbnda_adm3_nso_20181016_csas)

## Plot the map of West Pokot with the CSAS sample
plot(mwi_admbnda_adm3_nso_20181016, lwd = 2)
plot(grid_mwi_admbnda_adm3_nso_20181016_csas, col = "blue", lwd = 1, add = TRUE)
plot(sp_mwi_admbnda_adm3_nso_20181016_csas, col = "red", add = TRUE)

## Create a S3M sampling grid of mwi_admbnda_adm3_nso_20181016
sp_mwi_admbnda_adm3_nso_20181016_s3m <- create_sp_grid(x = mwi_admbnda_adm3_nso_20181016,
                                 area = mwi_admbnda_adm3_nso_20181016Area/100,
                                 country = "Malawi",
                                 type = "s3m")

## Create a SpatialPolygons object showing the hexagonal grid for the S3M sample
grid_mwi_admbnda_adm3_nso_20181016_s3m <- HexPoints2SpatialPolygons(sp_mwi_admbnda_adm3_nso_20181016_s3m)

## Plot the map of Malawi with the S3M sample
plot(mwi_admbnda_adm3_nso_20181016, lwd = 2)
plot(grid_mwi_admbnda_adm3_nso_20181016_s3m, border = "blue", lwd = 1, add = TRUE)
plot(sp_mwi_admbnda_adm3_nso_20181016__s3m, col = "red", pch = 20, add = TRUE)

## Move the sampling points to the location of the villages nearby

village_locations <- readOGR(dsn = "mwi_adm_nso_20181016_shp",
                             layer = "mwi_admbnda_adm3_nso_20181016")

## subset village_locations to those that are only in Dowa
mwi_admbnda_adm3_nso_20181016_village_locations <- village_locations[DowaDistrict_MW204, ]

## Select the nearest 1 village to the sampling points
sp_villages_mwi_admbnda_adm3_nso_20181016_s3m <- get_nearest_point(
                        data = mwi_admbnda_adm3_nso_20181016_village_locations@data, 
                  data.xb="Shape_Leng", data.y = "Shape_Area",
                  query = sp_mwi_admbnda_adm3_nso_20181016_s3m
)

