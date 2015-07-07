# I'm developing on Ubuntu, and I don't know what you're running, dear reader, so for compatibility...
if('downloader'%in%installed.packages()[,1]){
  library("downloader")
} else {
install.packages("downloader")
library("downloader")
}

# We don't want to download 20MB every time! If you already have the file, you can rename it to
# "exdata data household_power_consumption.zip" and put it in the working directory
dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile <- "exdata data household_power_consumption.zip"
if(file.exists(zipfile)) { print("We already have the file") } else {
  download(dataurl, zipfile ,mode="wb")
}

if(file.exists(toString(unzip(zipfile,list = TRUE)[1]))){
  print("... and it's already unzipped!")
} else {
  datafile <- unzip(zipfile)
}
# And let's get this data into R!
# optimising the read with tricks from
# http://www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html

tab5rows <- read.table(datafile, header = TRUE, sep = ";", nrows = 5)
classes <- sapply(tab5rows, class)
print("Starting alldata read")
alldata <- read.table(datafile, 
                      header = TRUE, 
                      sep = ";", 
                      na.strings = "?", 
                      nrows = 2075260, 
                      colClasses=classes)
print("Done! Starting altdata read...")
altdata <- read.table(datafile, 
                      header = TRUE, 
                      sep = ";", 
                      na.strings = "?", 
                      skip=66636,
                      nrows = 2880,
                      colClasses=classes,
                      col.names=colnames(tab5rows))
print("Done! Subsetting alldata...")
alldata$Date <- as.Date(strptime(alldata$Date, "%d/%m/%Y")) # from Factor to Date object
alldata$Time <- strptime(alldata$Time, "%H:%M:%S")

ourdates <- as.Date(strptime(c("2007-02-01", "2007-02-02"),"%Y-%m-%d"))
ourdata <- subset(alldata,alldata$Date%in%ourdates)
print("Done!")
rm(alldata)
ourdata <- altdata

## Plot the data
png(filename="plot1.png")
hist(ourdata$Global_active_power, 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")
# axis(1)
# par(yaxp=c(0,1200,6), ps=9)
# axis(2)
dev.off()