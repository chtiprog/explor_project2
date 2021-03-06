fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# Download and unzip the data file if it does not exist already
if (!file.exists("exdata_data_NEI_data.zip")) {
  download.file(fileUrl, destfile="exdata_data_NEI_data.zip", method="curl")
  unzip("exdata_data_NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999–2008?

# Filter only the data corresponding to "coal" in the table SCC
scc_level4 <- SCC[ , c("SCC", "SCC.Level.Four")]
scc_coal <- scc_level4[grepl("Coal", as.character(scc_level4$SCC.Level.Four)), ]

library(dplyr)
# Convert NEI and scc_coal in data.frame to use with dplyr
data_nei = data.frame(NEI)
data_scc = data.frame(scc_coal)

# Using our filter "data_scc", select only data in NEI with SCC
data <- filter(data_nei, SCC %in% data_scc$SCC)

by_year <- group_by(data, year)
coal_over_year <- summarize(by_year, emissions = sum(Emissions))

# Plotting :
png("plot4.png", width = 480, height = 480, units = "px")
plot(data.frame(select(coal_over_year, year), select(coal_over_year, emissions)), 
     type = "l", ylab = "PM2.5 emission", main = "emissions from coal combustion from 1999-2008")
dev.off()