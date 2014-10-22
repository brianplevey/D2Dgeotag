# Update on 7/5/2014

setwd('f:\\code\\D2D\\geolocation')


# function to show duplicate events
showDups <- function(x, data=data){
  tmp <- table(x)
  tmp <- tmp[as.character(x)]
  tmp <- data[tmp>1,]
  return(tmp)
}



############################################
# read in calais output
files <- list.files('eventsData\\calais')

cal <- data.frame()
for(i in files){
  f <- paste('f:\\code\\D2D\\geolocation\\eventsData\\calais\\', i, sep='')
  tmpc <- read.delim(f, sep=',', header=T, stringsAsFactors=F)
  cal <- rbind(cal, tmpc)
}

rm(files, i, f, tmpc)

  
head(cal)
names(cal)

cal <- subset(cal, select=c(eventID, city.province.state, locationType, X...latitude, X...longitude))

names(cal) <- c('event_Id', 'location', 'type', 'calLat', 'calLon')
head(cal)


############################################
# remove dups - location is the same for each matched pair
length(cal$event_Id)
length(unique(cal$event_Id))

tmp <- table(cal$event_Id)
tmp <- tmp[which(tmp>1)]
tmp <- names(tmp)
cal[which(cal$event_Id %in% as.numeric(tmp)),]
rm(tmp)

cal <- cal[!duplicated(cal$event_Id),]


############################################
# look for bad lat/long
table(cal$calLat)
table(cal$calLon)

id <- which(cal$calLat==123456)
cal <- cal[-id,]
rm(id)



############################################
# pull events that were tagged to a country, set all non-nigerian events to Int
table(cal$type)

id <- which(cal$type=='Country')
tmp <- cal[id,]
cal <- cal[-id,]

table(tmp$location)
tmp$location <- ifelse(tmp$location!='Nigeria', 'Int', tmp$location)
out <- tmp
rm(id, tmp)


############################################
# pull events that were tagged to a region, set all non-nigerian events to Int
id <- which(cal$type=='ProvinceOrState')
tmp <- cal[id,]
cal <- cal[-id,]

table(tmp$location)
id <- grep('Nigeria', tmp$location)
tmpINT <- tmp[-id,]
tmp <- tmp[id,]

tmpINT$location <- 'Int'
out <- rbind(out, tmpINT)

tmp$location <- gsub(',Nigeria', '', tmp$location)
table(tmp$location)

out <- rbind(out, tmp)
rm(id, tmpINT, tmp)



############################################
# merge city locations to regions
head(cal)

id <- grep('Nigeria', cal$location)
tmp <- cal[-id,]
cal <- cal[id,]

tmp$location <- 'Int'
out <- rbind(out, tmp)
rm(id, tmp)


library(raster)

load('gadm\\NGA_adm1.Rdata')

loc <- data.frame(longitude=cal$calLon, latitude=cal$calLat)
loc <- SpatialPoints(loc, proj4string=gadm@proj4string)
loc <- over(loc, gadm)

cal$location <- loc$NAME_1

out <- rbind(out, cal)
rm(loc, cal, gadm)




############################################
# clean up regions
table(out$location)

out$location <- sub(' State', '', out$location)
out$location <- sub('Abuja,', '', out$location)



############################################
# save merged file
calais <- out
save(calais, file='eventsData\\calaisLocations.Rdata')
