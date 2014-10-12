# This function downloads and unzips household_power_consumption.zip from web site
# It limits the dataset to the 1st and 2nd February
# It then plots Global Active power against week days/times
# Code assumes sqldf and lubridate packages are installed
plot2 <- function() {
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
    datetimes <- data.frame(cbind(householddata$Date, householddata$Time))
    library(lubridate)
    householddata$Date <- dmy(householddata$Date)
    householddata$Time <- hms(householddata$Time)
    
    datetimes <- householddata$Date + householddata$Time
    
    # Plot Global Active Power against weekdays and time - 480 * 480 png file in pixels 
    png(file = "plot2.png", width = 480, height = 480, units = "px") 
    with(householddata, plot(datetimes, Global_active_power, type='l', xlab="", ylab="Global Active Power (kilowatts)"))
    dev.off()
}