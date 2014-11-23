#install packages load libraries
install.packages("sqldf")
install.packages('dplyr')
library(sqldf)
library(dplyr)
source("http://sqldf.googlecode.com/svn/trunk/R/sqldf.R")

source("getData.R")

#create tbl_df objects
sqlNEI <- tbl_df(NEI)

#Summarise the data
sqlNEIYear <- 
    sqlNEI %>%
    filter(fips=="24510") %>%
    select(year,Emissions) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

#Open the png file
png(file = "plot2.png",width = 480, height = 480, units = "px") 

#create the plot
with(sqlNEIYear,plot(year,total
                 ,col="red"
                 ,xlab = "Year"
                 ,ylab = "PM2.5"
                 ,type = "l"
                 ,main = "Total Emissions for Baltimore City, Maryland (fips == 24510)"
            )
    )


#close the png file
dev.off()
