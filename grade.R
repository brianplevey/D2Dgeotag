# Updated 7-8-2014
# Select randomly for accuracy grading


setwd('f:\\code\\D2D\\geolocation')

load('eventsData\\nigeriaEvents.Rdata')

head(data)
names(data)

data <- subset(data, select=c(story_id, event_Id, event_Sentence, Source_Actor_Name, 
                              Target_Actor_Name, Event_type_Name, lspotRegion,
                              calRegion, hugoRegion))


####################################################
# remove any event_Ids that have been graded
load('trainAndTest\\nigeria.training.20140708.Rdata')

id <- train$event_Id
data <- data[-which(data$event_Id %in% id),]

rm(id, train)



####################################################
# Test Set 1
# randomly select 100 for testing set

samp <- sample(x=1:length(data$event_Id), size=500, replace=F)

test <- data[samp,]
data <- data[-samp,]
rm(samp)




####################################################
# Training Set
reg <- paste(data$lspotRegion, data$calRegion, data$hugoRegion, sep='-')
t <- table(reg)
t <- 1 - t/sum(t)
t <- t[reg]

set.seed(1234)
id <- sample(x=1:length(data$event_Id), size=200, replace=F, prob=t)

train <- data[id,]
table(paste(train$lspotRegion, train$calRegion, train$hugoRegion, sep='-'))

rm(reg, t, id)


####################################################
# save the testing and training sets
write.table(test, 'trainAndTest\\nigeria.test.20140708.csv', row.names=F,
            col.names=T, sep=',', quote=3:6, qmethod='double')


write.table(train, 'trainAndTest\\nigeriaTrainSet.20140707.txt', row.names=F,
            col.names=T, sep='\t')

