# Updated 7-7-2014
# Merge events, calais, and hugo

setwd('f:\\code\\D2D\\geolocation')


####################################################
# read events data, hugo, and calais
load('eventsData\\nigeriaEvents.Rdata')
load('eventsData\\calaisLocations.Rdata')
load('eventsData\\hugoLocated.Rdata')

names(data)
names(calais)
names(hugo)

calais <- subset(calais, select=c(event_Id, location))
names(calais)[2] <- 'calRegion'

names(hugo)[2] <- 'hugoRegion'

# merge the data
data <- merge(events, calais, by='event_Id', all.x=T, all.y=F)
data <- merge(data, hugo, by='event_Id', all.x=T, all.y=F)

head(data)
names(data)

rm(events, calais, hugo)

  

####################################################
# set missing country / regions to international
data$lspotRegion[which(is.na(data$lspotRegion))] <- 'unknown'
data$calRegion[which(is.na(data$calRegion))] <- 'unknown'
data$hugoRegion[which(is.na(data$hugoRegion))] <- 'unknown'

table(data$lspotRegion)
table(data$calRegion)
table(data$hugoRegion)



####################################################
# make sure the region names are standardized over coders / true region

load('gadm\\NGA_adm1.Rdata')
regions <- gadm$NAME_1
regions
regions <- regions[-which(regions=='Water body')]

unique(data$lspotRegion[!(data$lspotRegion %in% regions)])
unique(data$calRegion[!(data$calRegion %in% regions)])
unique(data$hugoRegion[!(data$hugoRegion %in% regions)])


### - keep original spelling Nasarawa
data$calRegion <- ifelse(data$calRegion=='Nasarawa', 'Nassarawa', data$calRegion)
data$hugoRegion <- ifelse(data$hugoRegion=='Nasarawa', 'Nassarawa', data$hugoRegion)

regions <- c(regions, 'unknown', 'Nigeria', 'Int')
regions <- as.factor(regions)
lvl <- levels(regions)

data$lspotRegion <- factor(data$lspotRegion, levels=lvl, labels=lvl)
data$calRegion <- factor(data$calRegion, levels=lvl, labels=lvl)
data$hugoRegion <- factor(data$hugoRegion, levels=lvl, labels=lvl)

rm(gadm, lvl, regions)


####################################################
# Save output
save(data, file='eventsData\\nigeriaEvents.Rdata')




