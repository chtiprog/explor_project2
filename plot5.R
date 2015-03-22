fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# Download and unzip the data file if it does not exist already
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(fileUrl, destfile="exdata_data_NEI_data.zip", method="curl")
  unzip("exdata_data_NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City? 

# Select from SCC only rows corresponding to "vehicle"
vehicle <- SCC[grepl("Vehicle", as.character(SCC$Short.Name)), ]
# Select only data for Baltimore
baltimore <- NEI[NEI$fips == "24510", ]

library(dplyr)
# convert our data in data.frame to use dplyr :
data_vehicle <- data.frame(vehicle)
data_baltimore <- data.frame(baltimore)

# Using our filter "data_vehicle", select only data in NEI with SCC
data <- filter(data_baltimore, SCC %in% data_vehicle$SCC)

by_year <- group_by(data, year)
vehicule_over_year <- summarize(by_year, emissions = sum(Emissions))

# Plotting :
png("plot5.png", width = 480, height = 480, units = "px")
plot(data.frame(select(vehicule_over_year, year), select(vehicule_over_year, emissions)), type = "l", ylab = "PM2.5 emission", main = "emissions from motor vehicle from 1999-2008 in Baltimore")
dev.off()

