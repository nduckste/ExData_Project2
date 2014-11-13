#install packages load libraries
install.packages("sqldf")
install.packages('dplyr')
install.packages('ggplot2')
library(sqldf)
library(dplyr)
library(ggplot2)
source("http://sqldf.googlecode.com/svn/trunk/R/sqldf.R")

source("getData.R")

#create subset of data for vehicles
mv <- SCC[grep("vehicles",SCC$EI.Sector,ignore.case = TRUE),]
#merge datasets
NEI_mv <- merge(NEI,mv,by.x="SCC",by.y="SCC",all=FALSE)

#create tbl_df objects
sqlNEI <- tbl_df(NEI_mv)

#Summarise the data
sqlNEIYear <- 
    sqlNEI %>%
    filter(fips=="24510") %>%
    select(year,type,Emissions) %>%
    group_by(year,type) %>%
    summarise(total = sum(Emissions))

#Open the png file
png(file = "plot5.png",width = 480, height = 480, units = "px") 

#create the plot
qplot(year,total
      ,data=sqlNEIYear
      ,geom=c("point","smooth")
      ,ylab="PM2.5"
      ,main="Motor Verhicle Emissions for Baltimore City"
    )


#close the png file
dev.off()
