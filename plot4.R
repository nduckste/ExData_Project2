#install packages load libraries
install.packages("sqldf")
install.packages('dplyr')
library(sqldf)
library(dplyr)
source("http://sqldf.googlecode.com/svn/trunk/R/sqldf.R")

source("getData.R")

#create subset of data for coal data
coal <- SCC[grep("fuel comb",SCC$EI.Sector,ignore.case = TRUE),]
coal <- coal[grep("coal",coal$EI.Sector,ignore.case = TRUE),]

#merge datasets
NEI_coal <- merge(NEI,coal,by.x="SCC",by.y="SCC",all=FALSE)

#create tbl_df objects
sqlNEI <- tbl_df(NEI_coal)

#Summarise the data
sqlNEIYear <- 
    sqlNEI %>%
    select(year,Emissions) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

#Open the png file
png(file = "plot4.png",width = 480, height = 480, units = "px") 

#create the plot
with(sqlNEIYear,plot(year,total
                     ,col="red"
                     ,xlab = "Year"
                     ,ylab = "PM2.5"
                     ,type = "l"
                     ,main="Coal Emissions"
    )
)


#close the png file
dev.off()