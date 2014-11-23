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
# NEI_mv <- merge(NEI,mv,by.x="SCC",by.y="SCC",all=FALSE)
NEI_mv <- inner_join(NEI,mv, by=c("SCC"))

#create tbl_df objects
sqlNEI <- tbl_df(NEI_mv)

#remove NEI_mv variable
rm(NEI_mv)

#Summarise the data
sqlNEIYear <- 
    sqlNEI %>%
    filter(fips %in%  c("24510","06037")) %>% #Filter on Baltimore and Los Angeles fips
    mutate(city = factor(fips, labels = c("Los Angelese County, California","Baltimore City, Maryland"))) %>%
    select(year,fips,city,Emissions) %>%
    group_by(year,city) %>%
    summarise(total = sum(Emissions))

#Open the png file
png(file = "plot6.png",width = 480, height = 480, units = "px") 

#create the plot
# qplot(year,total
#       ,data=sqlNEIYear
#       ,geom=c("point","smooth")
#       ,method="lm"
#       ,color=city
#       ,main="Motor Vehicle Emissions"
#       ,ylab=expression(PM[2.5])
# )
g <- ggplot(data=sqlNEIYear,aes(year,total))
g + 
    geom_point() +
    geom_smooth(method = "lm") +
    facet_grid(. ~ city) +
    labs(y = expression(PM[2.5]), x = "Year") +
    scale_y_continuous(breaks=seq(0, 6000, 200))
#     scale_y_continuous(limits=c(0,6000),breaks=seq(0, 6000, 500))
#     coord_cartesian(ylim = c(0, 6000)) 


#close the png file
dev.off()
