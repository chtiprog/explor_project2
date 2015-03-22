fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# Download and unzip the data file if it does not exist already
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(fileUrl, destfile="exdata_data_NEI_data.zip", method="curl")
  unzip("exdata_data_NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.
maryland_data <- NEI[NEI$fips == "24510", ]

library(dplyr)
maryland_data <- tbl_df(maryland_data)

# Grouping and filtring
by_year <- group_by(maryland_data, year)
emission_sum <- summarize(by_year, total_emissions = sum(Emissions))
year <- select(emission_sum, year)
total_emissions <- select(emission_sum, total_emissions)

# Plotting
png("plot2.png", width = 480, height = 480, units = "px")
plot(data.frame(year, total_emissions), type = "l", ylab = "total PM2.5 emission", main = "total emissions from PM2.5 in Baltimore from 1999-2008")
dev.off()