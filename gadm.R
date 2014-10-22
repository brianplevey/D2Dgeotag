# prep the GADM admin regions raster for mapping lat / long to regions

setwd('f:\\code\\D2D\\geolocation')


library(sp)
library(raster)


####################################################
# Load GADM spatial data

load('gadm\\NGA_adm1.Rdata')


head(gadm)

gadm@data
gadm@polygons[1]
gadm@plotOrder
gadm@bbox
gadm@proj4string

plot(gadm)


# NAME_1 is the region
gadm$NAME_1

# NAME_2 is the state
gadm$NAME_2

# NAME_3 is the city
gadm$NAME_3



