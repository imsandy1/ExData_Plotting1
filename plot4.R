library(data.table)
library(dplyr)
library(lattice)

##Download & unzip data file into working directory
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "powerdata.zip")
unzip("powerdata.zip")

##Read all data into a data frame 
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)
head(data)
names(data)

##Convert data column into class-date, and time column into class-posixct
data[,1] <- as.Date(data[,1], format = "%d/%m/%Y")
data[,2] <- as.POSIXct(strptime(paste(data[,1], " ", data[,2]), format = "%Y-%m-%d %H:%M:%S", tz = ""))
head(data[,1])

##Subset data into data2 for the given two dates. Convert it into tbl_df.
data2 <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")
head(data2)
data3 <- tbl_df(data2)
head(data3)

##Convert character values to numeric for columns 3:9
for (i in 3:9) { data3[,i] <- as.numeric(data2[,i]) }

##Open png device with the required dimensions
png("plot4.png", width = 480, height = 480)

##set mfrow for a 2x2 split of the canvas
par(mfrow = c(2, 2))

##Plot first chart
plot(x = data3$Time, y = data3$Global_active_power, type = "l", col = "black", xlab = "", ylab = "Global Active Power")

##plot second chart
plot(x = data3$Time, y = data3$Voltage, type = "l", col = "black", xlab = "datetime", ylab = "Voltage")

##Plot third chart
plot(x = data3$Time, y = data3$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
lines(x = data3$Time, y = data3$Sub_metering_2, type = "l", col = "red")
lines(x = data3$Time, y = data3$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1, 1, 1), bty = "n")

##Plot fourth chart
plot(x = data3$Time, y = data3$Global_reactive_power, type = "l", col = "black", xlab = "datetime", ylab = "Global_reactive_power")

##Close device
dev.off()
