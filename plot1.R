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
## This should be an efficient way to read the file into R
# > system.time(source("plot1.R")) # for example
#  user  system elapsed 
# 0.392   0.008   0.398 

tab5rows <- read.table(datafile, header = TRUE, sep = ";", nrows = 5)
classes <- sapply(tab5rows, class)

ourdata <- read.table(datafile, 
                      header = TRUE, 
                      sep = ";", 
                      na.strings = "?", 
                      skip=66636, # These numbers correspond to values
                      nrows = 2880, # for dates 2007-02-01 and 2007-02-02
                      colClasses=classes,
                      col.names=colnames(tab5rows))

ourdata$Date <- as.Date(strptime(ourdata$Date, "%d/%m/%Y")) # from Factor to Date object
ourdata$Time <- strptime(ourdata$Time, "%H:%M:%S")

## Plot the data
png(filename="plot1.png")
hist(ourdata$Global_active_power, 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     col = "red")
dev.off()