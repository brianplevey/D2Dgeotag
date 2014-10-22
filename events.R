# Updated 10-8-2014
# Prepare the event data files
# There were multiple duplicated event_Ids. Duplicate events were removed.
# The files were merged into one event file.
# Two outputs were created:
#   1 to be used as input for HuGo
#   2 to be used to map HuGo and Calais output back to original events

dir <- 'f:\\code\\D2D\\geolocation'

dir <- 'v:\\SAE\\projects\\D2D\\Binned Stories\\SudanLMLocations' 

setwd(dir)


# function to show duplicate events
showDups <- function(x, data=data){
  tmp <- table(x)
  tmp <- tmp[as.character(x)]
  tmp <- data[tmp>1,]
  return(tmp)
}

files <- list.files(dir)

cols <- c('event_Id', 'eventtype_id', 'verbrule', 'story_id', 'text', 'event_date', 
          'coder_id', 'sentence_num', 'Source_Actor_Name', 'Target_Actor_Name', 
          'Event_type_Name', 'Event_code', 'Target_context_code', 'Target_country', 
          'target_country_id', 'source_context_code', 'Source_Country', 'source_country_id', 
          'event_Sentence', 'location_id', 'entityText', 'City', 'Province', 
          'Latitude', 'Longitude', 'country_id', 'District', 'Area', 'geonameid', 'country_name')
data <- data.frame()

for(i in 1:length(files)){
  path <- paste(dir, files[i], sep='\\')
  tmp <- read.delim(path, sep=',', header=F, stringsAsFactors=F, quote='"', col.names=cols, skip=1)
  data <- rbind(data, tmp)
  rm(tmp)
}

rm(files, i, path, cols)

names(data)
head(data)


# check for duplicated events
length(data$event_Id)
length(unique(data$event_Id))

length(data$event_Id) - length(unique(data$event_Id))


tmp <- table(data$event_Id)
tmp <- ifelse(tmp>1, 1, 0)
tmp <- tmp[as.character(data$event_Id)]
tmp <- data[which(tmp==1),]
tmp <- tmp[order(tmp$event_Id),]
tmp[1:25,]

data <- data[!duplicated(data$event_Id),]
rm(tmp)




###########################################
# save event data file
events <- data
save(events, file='v:\\SAE\\projects\\D2D\\geolocation\\HuGo\\sudans\\sudanEvents.Rdata')


# prep file for HuGo input
names(events)
events <- subset(events, select=c(event_Id, story_id, sentence_num,
                                  Source_Actor_Name, Target_Actor_Name, Event_type_Name,
                                  event_Sentence))


# for geotagging using full stories
file <- events$story_id
out <- cbind(file, events)

write.table(out, file='v:\\SAE\\projects\\D2D\\geolocation\\HuGo\\sudans\\hugoInput_sudanEvents_fullstory.txt', 
            sep='\t', row.names=F, col.names=T)


# for geotagging using sub stories
file <- events$event_Id
out <- cbind(file, events)
out$sentence_num <- 2

write.table(out, file='v:\\SAE\\projects\\D2D\\geolocation\\HuGo\\sudans\\hugoInput_sudanEvents_substory.txt', 
            sep='\t', row.names=F, col.names=T)
!SAEbl108~
