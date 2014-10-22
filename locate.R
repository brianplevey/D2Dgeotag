# Review graded output
# run 7-7-2014


setwd('f:\\code\\D2D\\geolocation')

load('eventsData\\nigeriaEvents.Rdata')
names(data)


################################################
# load the training set
load('trainAndTest\\nigeria.training.20140708.Rdata')

train <- subset(train, select=c(event_Id, trueRegion))


# merge to events data
data <- merge(data, train, by='event_Id', all.x=T, all.y=F)
rm(train)



####################################################
# make sure the training region names are standardized over coders / true region

load('gadm\\NGA_adm1.Rdata')

regions <- gadm$NAME_1
regions
regions <- regions[-which(regions=='Water body')]

unique(data$trueRegion[!(data$trueRegion %in% regions)])
regions <- c(regions, 'unknown', 'Nigeria', 'Int')
regions <- as.factor(regions)
lvl <- levels(regions)

data$trueRegion <- factor(data$trueRegion, levels=lvl, labels=lvl)
rm(gadm, lvl, regions)


################################################
# make model using e1071 naive bayes
library(e1071)

tmp <- data[-which(is.na(data$trueRegion)),]

mod <- naiveBayes(trueRegion ~ lspotRegion + calRegion + hugoRegion, data=tmp)
pr <- predict(mod, data)


table(ifelse(data$trueRegion==pr, 1, 0))

data$region <- pr
table(is.na(data$region))

rm(tmp, mod, pr)


# some fixes that will not always be needed
# change sp of nassarawa
data$region <- as.character(data$region)
data$region[which(data$region=='Nassarawa')] <- 'Nasarawa'
table(data$region)

# drop unknown region
data <- data[-which(data$region=='unknown'),]



################################################
# save output
names(data)
out <- data[,c(1:19,35)]
names(out)

save(data, file='eventsData\\nigeriaEvents.geolocated.Rdata')

write.table(out, file='eventsData\\nigeriaEvents.geolocated.csv', 
            row.names=F, col.names=T, sep=',', quote=T, qmethod='double')




################################################
# make model using rpart
library(rpart)

tmp <- data[-which(is.na(data$trueRegion)),]

mod <- rpart(trueRegion ~ lspotRegion + calRegion + hugoRegion, data=tmp, method='class')
printcp(mod)
summary(mod)

pr <- predict(mod, newdata=data)
table(pr)




################################################
# TESTING
# Construct a 'truth region' based on agreement of three coders to use in model
table(ifelse(data$lspotRegion == data$calRegion &
               data$lspotRegion == data$hugoRegion, 1, 0))

reg <- rep(NA, length(data[,1]))
id <- which(data$lspotRegion == data$calRegion & data$lspotRegion == data$hugoRegion)
reg[id] <- as.character(data$lspotRegion[id])
reg <- factor(reg, levels=levels(regions))

rm(id)
