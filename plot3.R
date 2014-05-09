## Author: Brian von Konsky
## Created: 7 May 2014
## Course:  Exploratory Data Analysis

#if the subdirectory with the original data doesn't exist, download and unzip it
getData.eda_project1 <- function() {
  ## Set file names
  original <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  directory <- "data"
  zip    <- "exdata_data_household_power_consumption.zip"
  data <- "household_power_consumption.txt"
  
  ## Set OS independentn paths to the files
  path.zip <- file.path(directory, zip)
  path.data<- file.path(directory, data)
  
  ## If the directory doesn't exist, then get it
  if (!file.exists(path.data)) {
    
    if (!file.exists(directory))
      dir.create(directory)
    
    ## Download and unzip
    download.file(original, path.zip, method="curl" )
    unzip(path.zip, exdir=directory)
  }
  
  ## read data from the text file
  theData <- read.table(path.data, header=TRUE, sep=";", stringsAsFactors=FALSE)
  
  ## Convert character data to Date and Time class
  theData$Time <- strptime(do.call(paste, theData[c(1,2)]), "%e/%m/%Y %H:%M:%S")
  theData$Date <- as.Date(theData$Date, "%e/%m/%Y")
  
  ## Convert ? to NA and make variables numeric
  theData[3:9] <- lapply(theData[3:9], function (x) as.numeric(gsub("\\?", NA, x)))
  return (theData)
}

#Draw plot3
plot3 <- function() {
  png("plot3.png", width=480, height=480, bg="transparent")
  par(mfrow=c(1,1), mar=c(5,4,1,1))
  with (twoDays, plot(Time, Sub_metering_1, col="black", type="l", xlab="", ylab="Energy sub metering" ))
  with (twoDays, lines(Time, Sub_metering_2, col="red"))
  with (twoDays, lines(Time, Sub_metering_3, col="blue"))
  legend("topright", c ("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c("black", "red", "blue"))
  dev.off()
}

# load the data
fullData <- getData.eda_project1()
twoDays  <- subset(fullData, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

# draw the plot
plot3()