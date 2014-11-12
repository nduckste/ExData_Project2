## getData.R
## Author: Nick
## Date: 2014-11-13
## Class: JHBSPH - Exploratory Data Analysis
## Project: 2

## The getData.R script needs to be run first. It will download the data from the website to a local copy.
## It will then create a data frame. It will set the 
## column data types appropriately and add a column for datetime which are the date and time columns joined 
## together. If household_power_consumption.txt is already in the local directory then it will use that copy 
## instead of downloading a fresh one from the website.

## 
## getData.R will output a data frame called "data" that will be used be each of the subsequent 
## scripts to produce the plots.


#setwd("~/School/JH/04 Exploratory Data Analysis/Projects/ExData_Plotting1/ExData_Plotting1")
setwd("C:/R/Course4-ExploratoryDataAnalysis")

# check if file already exists, if not, download. if exists using existing copy
if (!file.exists("summarySCC_PM25.rds")){
  
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  # create a temporary directory
  td = tempdir()

  # create the placeholder file
  tf = tempfile(tmpdir=td, fileext=".zip")

  # download into the placeholder file
  download.file(fileUrl, tf)

  #get the filenames in the zip file
  fnames <- unzip(tf,list=TRUE)
  
  #loop throw the data.frame
  for (i in 1:nrow(fnames)) {
    #get the current file
    fname = fnames[i,"Name"]
    print (fname)
    
    # unzip the file to the temporary directory
    unzip(tf, files=fname, exdir=td, overwrite=TRUE)
    
    # fpath is the full path to the extracted file
    fpath = file.path(td, fname)
    
    #copy to local
    file.copy(fpath, fname)
  }
}

#get data out of file and into dataframe
data <- read.table("household_power_consumption.txt", sep=";", header = TRUE)
PowerData <- data[(data$Date == "2/2/2007" | data$Date == "1/2/2007"),]
rm(data)

#set column datatypes
PowerData$DateTime = strptime( (paste(PowerData$Date,PowerData$Time )), "%d/%m/%Y %H:%M:%S") 
PowerData$Date = strptime(PowerData$Date, "%d/%m/%Y")
PowerData$Time = strptime(PowerData$Time, "%H:%M:%S")
PowerData$Global_active_power = as.double(as.character(PowerData$Global_active_power))
PowerData$Global_reactive_power = as.double(as.character(PowerData$Global_reactive_power))
PowerData$Voltage = as.double(as.character(PowerData$Voltage))
PowerData$Global_intensity = as.double(as.character(PowerData$Global_intensity))
PowerData$Sub_metering_1 = as.double(as.character(PowerData$Sub_metering_1))
PowerData$Sub_metering_2 = as.double(as.character(PowerData$Sub_metering_2))
PowerData$Sub_metering_3 = as.double(as.character(PowerData$Sub_metering_3))