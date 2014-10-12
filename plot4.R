# This function downloads and unzips household_power_consumption.zip from web site
# It limits the dataset to the 1st and 2nd February
# It then plots 4 different graphs using the dataset
# Code assumes sqldf and lubridate packages are installed
plot4 <- function() {    
    # Download zip file, unzip and read into householddata data frame 
    library(sqldf)
    temp <- tempfile()
    householdpowerurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(householdpowerurl, temp)
    householdfile <- unz(temp, "./household_power_consumption.txt")
    householddata <- read.csv.sql("./household_power_consumption.txt", sql = "SELECT * from file
            WHERE Date in ('1/2/2007', '2/2/2007')", sep = ";", header = TRUE)
    unlink(temp)
    
    # Merge Data and Time to get Date/Time for plot
    library(lubridate)
    householddata$Date <- dmy(householddata$Date)
    householddata$Time <- hms(householddata$Time)

    datetimes <- householddata$Date + householddata$Time    
    
    # Plot all 4 graphs - 480 * 480 png file in pixels 
    png(file = "plot4.png", width = 480, height = 480, units = "px") 
    par(mfrow = c(2,2), mar=c(5,4,4,4))
    with(householddata, {
         plot(datetimes, Global_active_power, type='l', xlab="", ylab="Global Active Power")
         plot(datetimes, Voltage, type='l', xlab="datetime", ylab="Voltage")
         plot(datetimes, householddata$Sub_metering_1, type='l', xlab="", ylab="Energy sub metering")
         with(subset(householddata, !is.na(householddata$Sub_metering_1)), lines(datetimes,householddata$Sub_metering_1,col="black"))
         with(subset(householddata, !is.na(householddata$Sub_metering_2)), lines(datetimes,householddata$Sub_metering_2,col="red"))
         with(subset(householddata, !is.na(householddata$Sub_metering_3)), lines(datetimes,householddata$Sub_metering_3,col="blue"))
         legend("topright",bty="n",lwd=1,cex=.8,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
         plot(datetimes, Global_reactive_power, type='l', xlab="datetime", ylab="Global_reactive_power")
         })
    dev.off()
}
