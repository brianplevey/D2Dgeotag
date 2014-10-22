# Updated on 7/7/2014
# Combine hugo output into one file


setwd('f:\\code\\D2D\\geolocation')


# function to show duplicate events
showDups <- function(x, data=data){
  tmp <- table(x)
  tmp <- tmp[as.character(x)]
  tmp <- data[tmp>1,]
return(tmp)
}



############################################
# read in hugo output
data <- read.delim('eventsData\\HugoLocated.nigeria.csv', header=T, sep=',', stringsAsFactors=F)

data <- subset(data, select=c(event_Id, LOCATED.AS.))
names(data) <- c('event_Id', 'geonameid')


############################################
# remove events where hugo encountered an error
# convert to numeric, then remove the missing obs
table(data$geonameid)

#data <- data[-c(grep('Error', data$geonameid)),]
data <- data[-c(grep('UNKNOWN', data$geonameid)),]

data$geonameid <- as.numeric(data$geonameid)

table(is.na(data$geonameid))



############################################
# map each column of hugo output back to geonames ID
load('hugoDictionaries\\nigeria.geonames.Rdata')

data <- merge(data, geonames, by='geonameid', all.x=T, all.y=F)
names(data)

rm(geonames)



############################################
# remove Int locations using country
table(data$country)

id <- which(data$country!='NG')
tmp <- data[id,]
data <- data[-id,]

table(tmp$asciiname)

tmp$asciiname <- 'Int'
out <- tmp
rm(tmp, id)


############################################
# set location for events with missing lat/long
id <- which(is.na(data$latitude))

tmp <- data[id,]
data <- data[-id,]

table(tmp$asciiname)
tmp$asciiname <- 'Int'

out <- rbind(out, tmp)
rm(id, tmp)


############################################
# set location for events located as Nigeria
id <- grep('Federal Republic of Nigeria', data$asciiname)

tmp <- data[id,]
data <- data[-id,]

table(tmp$asciiname)

tmp$asciiname <- 'Nigeria'
out <- rbind(out, tmp)
rm(id, tmp)



############################################
# set locations for states
table(data$feature2)

id <- which(data$feature2=='ADM1')
tmp <- data[id,]
data <- data[-id,]

table(tmp$asciiname)
out <- rbind(out, tmp)
rm(id, tmp)


############################################
# set locations for remaining locations with lat/long

library(raster)

load('gadm\\NGA_adm1.Rdata')

loc <- data.frame(longitude=data$longitude, latitude=data$latitude)
loc <- SpatialPoints(loc, proj4string=gadm@proj4string)
loc <- over(loc, gadm)

data$asciiname <- loc$NAME_1

out <- rbind(out, data)
rm(loc, data, gadm)


############################################
# clean up regions
out <- subset(out, select=c(event_Id, asciiname))
names(out)[2] <- 'location'

table(out$location)

out$location <- sub(' State', '', out$location)
out$location <- sub('State of ', '', out$location)

id <- grep('Water body', out$location)
out <- out[-id,]



############################################
# save output
hugo <- out
save(hugo, file='eventsData\\hugoLocated.Rdata')
