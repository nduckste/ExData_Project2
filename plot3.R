#install packages load libraries
install.packages("sqldf")
install.packages('dplyr')
install.packages('ggplot2')
library(sqldf)
library(dplyr)
library(ggplot2)
source("http://sqldf.googlecode.com/svn/trunk/R/sqldf.R")

source("getData.R")

#create tbl_df objects
sqlNEI <- tbl_df(NEI)

#Summarise the data
sqlNEIYear <- 
    sqlNEI %>%
    filter(fips=="24510") %>%
    select(year,type,Emissions) %>%
    group_by(year,type) %>%
    summarise(total = sum(Emissions))

#Open the png file
png(file = "plot3.png",width = 480, height = 480, units = "px") 

#create the plot
qplot(year,total
      ,data=sqlNEIYear
      ,facets = type ~ .
      ,geom=c("point","smooth")
)


#close the png file
dev.off()
