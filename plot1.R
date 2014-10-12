
plot1 <- function() {
    # Download zip file, unzip and read into householddata data frame 
    library(sqldf)
    temp <- tempfile()
    householdpowerurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(householdpowerurl, temp)
    householdfile <- unz(temp, "./household_power_consumption.txt")
    householddata <- read.csv.sql("./household_power_consumption.txt", sql = "SELECT * from file
            WHERE Date in ('1/2/2007', '2/2/2007')", sep = ";", header = TRUE)
    unlink(temp)

    # Plot Global Active Power - 480 * 480 png file in pixels 
    png(file = "plot1.png", width = 480, height = 480, units = "px") 
    with(householddata, hist(Global_active_power, main = "Global Active Power", col="red", xlab="Global Active Power (kilowatts)"))
    dev.off()
}
