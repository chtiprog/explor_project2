fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# Download and unzip the data file if it does not exist already
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(fileUrl, destfile="exdata_data_NEI_data.zip", method="curl")
  unzip("exdata_data_NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

library(dplyr)
nei <- tbl_df(NEI)
# Grouping and filtring
by_year <- group_by(nei, year)
emission_sum <- summarize(by_year, total_emissions = sum(Emissions))
year <- select(emission_sum, year)
total_emissions <- select(emission_sum, total_emissions)

# make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.
png("plot1.png", width = 480, height = 480, units = "px")
plot(data.frame(year, total_emissions), type = "l", ylab = "total PM2.5 emission", main = "Total emissions from PM2.5 in USA from 1999-2008")
dev.off()

