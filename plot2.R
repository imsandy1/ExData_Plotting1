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

##Plot line chart
plot(x = data3$Time, y = data3$Global_active_power, type = "l", col = "black", xlab = "", ylab = "Global Active Power (kilowatts)")

##Copy plot to png and close device
dev.copy(device = png, filename = "plot2.png", width = 480, height = 480)
dev.off()
