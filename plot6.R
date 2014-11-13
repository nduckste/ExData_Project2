#install packages load libraries
install.packages("sqldf")
install.packages('dplyr')
install.packages('ggplot2')
library(sqldf)
library(dplyr)
library(ggplot2)
source("http://sqldf.googlecode.com/svn/trunk/R/sqldf.R")

#Set Working directory
setwd("C:/R/Course4-ExploratoryDataAnalysis/ExData_Project2")

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
    filter(fips %in%  c("24510","06037")) %>% #Filter on Baltimore and Los Angeles fips
    mutate(city = factor(fips, labels = c("Los Angelese County, California","Baltimore City, Maryland"))) %>%
    select(year,fips,city,Emissions) %>%
    group_by(year,city) %>%
    summarise(total = sum(Emissions))

dim(sqlNEIYear)
head(sqlNEIYear)

#Open the png file
png(file = "plot6.png",width = 480, height = 480, units = "px") 

#create the plot
qplot(year,total
      ,data=sqlNEIYear
      ,geom=c("point","smooth")
      ,method="lm"
      ,color=city
      ,main="Motor Vehicle Emissions"
      ,ylab=expression(PM[2.5])
)


#close the png file
dev.off()
