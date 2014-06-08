#plot4.R
#R code to obtain plot4.png
#in according to the sample figure
#Coursera
#Exploratory Data Analysis
#Course Project #1
#
#Preliminary steps:
#fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#if(!file.exists("data"))dir.create(data)
#download.file(fileURL, destfile="data/household_power_consumption.zip", method="curl")
#unzip("data/household_power_consumption.zip", exdir="data")
#Data file is downloaded in local directory, and ready to be explored.
#There are 2075259 rows in the household_power_consumption.txt file.
#So one need a function to read the data that would be 1) fast and 2) saving memory
library(data.table)##the labrary includes fread() function
#to avoide some warnings let fread() to get data just as characters: colClasses=list(character=1:9)
#and set a filter on date: [Date %in% c("1/2/2007","2/2/2007")]
powerData <- fread("data/household_power_consumption.txt", na.strings=c("?",""), 
                   colClasses=list(character=1:9))[Date %in% c("1/2/2007","2/2/2007")]
#Transform the column classes: 
powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y") ##in POSIX Date format
powerData$Time <- paste(powerData$Date, powerData$Time) ## just combine Date and Time as characters
#All other columns - to numeric
powerData$Global_active_power <- as.numeric(powerData$Global_active_power) 
powerData$Global_reactive_power <- as.numeric(powerData$Global_reactive_power)
powerData$Voltage <- as.numeric(powerData$Voltage)
powerData$Global_intensity <- as.numeric(powerData$Global_intensity)
powerData$Sub_metering_1 <- as.numeric(powerData$Sub_metering_1)
powerData$Sub_metering_2 <- as.numeric(powerData$Sub_metering_2)
powerData$Sub_metering_3 <- as.numeric(powerData$Sub_metering_3)
#open png graphics device 
#width = 480, height = 480 are default values so I can omit ones.. Just to keep in mind
png("plot4.png", width = 480, height = 480, units = "px")
#I need to set up standard locale for time formats
#because "Thu", "Fri", "Sat" in my locale have another names
Sys.setlocale(category = "LC_TIME", locale = "C")
#set grid for figures 2x2
par(mfrow=c(2,2))
#create plot by plot
#X-axis is character Date+Time string converted by strptime in POSIX time format
plot(strptime(powerData$Time, format="%Y-%m-%d %H:%M:%S"), 
     powerData$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
plot(strptime(powerData$Time, format="%Y-%m-%d %H:%M:%S"), 
     powerData$Voltage, type="l", xlab="datetime", ylab="Voltage")
plot(strptime(powerData$Time, format="%Y-%m-%d %H:%M:%S"), 
     powerData$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(strptime(powerData$Time, format="%Y-%m-%d %H:%M:%S"), 
      powerData$Sub_metering_2, col="red")
lines(strptime(powerData$Time, format="%Y-%m-%d %H:%M:%S"), 
      powerData$Sub_metering_3, col="blue")
legend("topright", legend=colnames(powerData)[7:9], col=c("black", "red", "blue"), lty=1, bty="n")
plot(strptime(powerData$Time, format="%Y-%m-%d %H:%M:%S"), 
     powerData$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
#return to native locale for time formats
Sys.setlocale(category = "LC_TIME", locale = "")
#png device off - file is ready
dev.off()