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

##Open png device, with required dimensions
png("plot3.png", width = 480, height = 480)

##Plot line chart for first variable
plot(x = data3$Time, y = data3$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering", width = 480, height = 480)

##Add line chart for the second and third variables
lines(x = data3$Time, y = data3$Sub_metering_2, type = "l", col = "red")
lines(x = data3$Time, y = data3$Sub_metering_3, type = "l", col = "blue")

##Add legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1, 1, 1))

##Close device
dev.off()
