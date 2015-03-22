fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# Download and unzip the data file if it does not exist already
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(fileUrl, destfile="exdata_data_NEI_data.zip", method="curl")
  unzip("exdata_data_NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

data_baltimore <- NEI[NEI$fips == "24510", ]

library(dplyr)

baltimore <- tbl_df(data_baltimore)

non_road <- filter(baltimore, type == "NON-ROAD")
non_road <- group_by(non_road, year)
non_road <- summarize(non_road, total_emission = sum(Emissions))

nonpoint <- filter(baltimore, type == "NONPOINT")
nonpoint <- group_by(nonpoint, year)
nonpoint <- summarize(nonpoint, total_emission = sum(Emissions))

on_road <- filter(baltimore, type == "ON-ROAD")
on_road <- group_by(on_road, year)
on_road <- summarize(on_road, total_emission = sum(Emissions))

point <- filter(baltimore, type == "POINT")
point <- group_by(point, year)
point <- summarize(point, total_emission = sum(Emissions))

# plotting the graph with these 3 data :
png("plot3.png", width = 480, height = 480, units = "px")
plot(data.frame(select(nonpoint, year), select(nonpoint, total_emission)), type = "l", ylab = "PM2.5 emission", col = "green")
lines(data.frame(select(non_road, year), select(non_road, total_emission)), type = "l", col = "red")
lines(data.frame(select(on_road, year), select(on_road, total_emission)), type = "l", col = "blue")
lines(data.frame(select(point, year), select(point, total_emission)), type = "l")
legend("topright", 
       legend = c("nonpoint", 
                  "non_road", 
                  "on_road",
                  "point"), 
       col = c("green", "red", "blue", "black"), 
       lwd = .75, 
       cex = .75
)
dev.off()

library(ggplot2)
