## This is how to read the whole file and subset it based on the dates we want.
## It takes AGES so I'd rather do the less semantic, but faster method of reading...
## ...only the lines we care about from the file
## The resulting plot is bit-for-bit identical to the one from plot1.R
tab5rows <- read.table(datafile, header = TRUE, sep = ";", nrows = 5)
classes <- sapply(tab5rows, class)

alldata <- read.table(datafile, 
                      header = TRUE, 
                      sep = ";", 
                      na.strings = "?", 
                      nrows = 2075260, 
                      colClasses=classes)
alldata$Date <- as.Date(strptime(alldata$Date, "%d/%m/%Y")) # from Factor to Date object
alldata$Time <- strptime(alldata$Time, "%H:%M:%S")

ourdates <- as.Date(strptime(c("2007-02-01", "2007-02-02"),"%Y-%m-%d"))
altdata <- subset(alldata,alldata$Date%in%ourdates)
## example system.time for this
# > system.time(source("alternatereader.R"))
#   user  system elapsed 
# 20.584   6.980  27.615 