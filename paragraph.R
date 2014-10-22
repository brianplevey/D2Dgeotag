# Read geolocation test / training sets, pull the 3 sentence stories and attach for more context
# Execute on server
# run 06/18/2014


setwd('v:\\SAE\\projects\\D2D')
load('truthset1.Rdata')



# function to pull the sentence before / after story and merge with event_Id
pullStory <- function(id, location){
  tmp <- data.frame(event_Id=id, sentBeforeAfter=NA)
  for(i in 1:length(id)){
    file <- paste(location, tmp[i,1], '.txt', sep='')
    tmp$sentBeforeAfter[i] <- readChar(file, file.info(file)$size)
  }
  return(tmp)
}


# merge sentences with each test/training set and write files out
tmp <- pullStory(id=testSet1$event_Id, location='Binned Stories\\SudanAllSentenceBeforeAfter\\singlefolder\\')
tmp$sentBeforeAfter <- gsub('\r\n', '', tmp$sentBeforeAfter)
testSet1 <- merge(tmp, testSet1, by='event_Id', all=T)
write.table(testSet1, file='testSet1.txt', col.names=T, row.names=F, sep='\t')


tmp <- pullStory(id=testSetHugo$event_Id, location='Binned Stories\\SudanAllSentenceBeforeAfter\\singlefolder\\')
tmp$sentBeforeAfter <- gsub('\r\n', '', tmp$sentBeforeAfter)
testSetHugo <- merge(tmp, testSetHugo, by='event_Id', all=T)
write.table(testSetHugo, file='testSetHugo.txt', col.names=T, row.names=F, sep='\t')


tmp <- pullStory(id=trainingSet1$event_Id, location='Binned Stories\\SudanAllSentenceBeforeAfter\\singlefolder\\')
tmp$sentBeforeAfter <- gsub('\r\n', '', tmp$sentBeforeAfter)
trainingSet1 <- merge(tmp, trainingSet1, by='event_Id', all=T)
write.table(trainingSet1, file='trainingSet1.txt', col.names=T, row.names=F, sep='\t')


    