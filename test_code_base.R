################################################################################
## Cusomizable input ###########################################################
################################################################################
start <- "01.07.2015" # any date around which the agenda should begin (dd.mm.yyyy)
monthly_pages <- 3 # number of pages for the monthly overview (1 page = 6 months)


################################################################################
## Set-Up, packages, and custom functions ######################################
################################################################################
invisible(Sys.setlocale("LC_ALL","English"))

library(dplyr)
library(reshape2)
library(lubridate)

wday(dmy("01.07.2015"), label=FALSE)
nextbestmonday <- function(start)   { #requires lubridate
  #wday(date) will return 1 for Sunday, 2 for Monday...
  start -     
  ifelse(wday(start) == 2, days(0),  
         ifelse(wday(start) == 3, days(1), 
                ifelse(wday(start) == 4, days(2), 
                       ifelse(wday(start) == 5, days(3), 
                              ifelse(wday(start) == 6, days(4), 
                                     ifelse(wday(start) == 7, days(5), 
                                            ifelse(wday(start) == 1, days(6))
                                     )
                              )
                       )
                )
         )
  )
}

nextbestsunday <- function(monthly_end)   { #requires lubridate
    monthly_end +     
      ifelse(wday(start) == 2, days(0), 
             ifelse(wday(start) == 3, days(6), 
                    ifelse(wday(start) == 4, days(5), 
                           ifelse(wday(start) == 5, days(4), 
                                  ifelse(wday(start) == 6, days(3), 
                                         ifelse(wday(start) == 7, days(2), 
                                                ifelse(wday(start) == 0, days(1))
                                         )
                                  )
                           )
                    )
             )
      )
}


################################################################################
## Calculating start and end dates #############################################
################################################################################
# Convert start into date and extract year and month 
start <- dmy(start)
?dmy
start_month <- month(start)
start_year <- year(start)

# Find the first and last date for the monthly overview 
monthly_start <- paste("01", start_month, start_year, sep=".")
monthly_start <- dmy(monthly_start)
monthly_length <- paste(monthly_pages*6, "months")
monthly_end <- seq.Date(as.Date(monthly_start), 
                        length=2, 
                        by=monthly_length
                        )[2] - 1
monthly_end <- ymd(monthly_end)

# Find first and last date for the weekly overview
weekly_start <- nextbestmonday(start)
weekly_end <- nextbestsunday(monthly_end) 


################################################################################
## Calculating the dates for the weekly overview ###############################
################################################################################
weekly_range <- seq(weekly_start, weekly_end, "days")
weekly_dates <- format(weekly_range, "%d.%m") #31.01
weekly_days <- format(weekly_range, "%A")     #Monday
weekly_weeks <- strftime(weekly_range,format="%W") #1
weekly_months <- format(weekly_range, "%B")   #January
weekly_years <- format(weekly_range, "%Y")    #2015
weekly_wknds  <- ifelse(wday(weekly_range) %in% c(7,1), TRUE, FALSE)  #weekends
weekly_df <- data.frame(weekly_dates, 
                         weekly_days, 
                         weekly_weeks, 
                         weekly_months, 
                         weekly_years, 
                         weekly_wknds)
# remove weekly_ from column names
colnames(weekly_df) <- gsub(".*\\_","",colnames(weekly_df))  


################################################################################
## Calculating the dates for the monthly overview ##############################
################################################################################
monthly_range <- seq(monthly_start, monthly_end, "days") #start on a Jul 01, end on Dec 31 (multiple of 6 months)
monthly_fulldates <- format(monthly_range, "%d.%m.%Y")
monthly_dates <- format(monthly_range, "%d")       #31
monthly_days <- format(monthly_range, "%a")     #Mon 
monthly_weeks <- strftime(monthly_range,format="%W") #1
monthly_months <- format(monthly_range, "%B")   #January
monthly_years <- format(monthly_range, "%Y")    #2015
monthly_wknds <- ifelse(wday(monthly_range) %in% c(7,1), TRUE, FALSE)  #weekends
monthly_df <- data.frame(monthly_fulldates, 
                         monthly_dates, 
                         monthly_days, 
                         monthly_weeks, 
                         monthly_months, 
                         monthly_years, 
                         monthly_wknds)
colnames(monthly_df) <- gsub(".*\\_","",colnames(monthly_df)) 




################################################################################
## Calculating the dates for the monthly overview ##############################
################################################################################
monthly_df$int <- interaction(monthly_df$months, monthly_df$years, sep=" ")

#dcast(data.frame, id variables ~ measured variables)
dcast(monthly_df, dates ~ int, value.var="days")
             


?dcast







monthly_df$sort <- as.numeric(monthly_df$months)



#id variables will get separate columns

#Sort factor levels of month by month (not alphabetical)
monthly_df$months <- factor(monthly_df$months, levels = month.name)



monthly_df$days <- as.character(monthly_df$days)

dcast(monthly_df, int + years + months + sort ~ dates, value.var="days")


dfcast <- dfcast[order(dfcast$years, dfcast$sort),] #sort by month instead of by alphabet
rownames(dfcast) <- dfcast$int
drops <- colnames(dfcast) %in% c("int", "years", "months", "sort")
dfcast <- dfcast[,!drops]
overview <- t(dfcast)









dfcast <- dcast(monthly_df, int + years + months + sort ~ dates, value.var="days")


dfcast <- dfcast[order(dfcast$years, dfcast$sort),] #sort by month instead of by alphabet



         

dcast(monthly_df, years + months ~ dates, value.var="days")

#dcast looses date format --> create dfcar with character entries of df
dfcar <- monthly_df
dfcar$days <- paste(dfcar$dates, dfcar$days, sep=" ") #31.01 Mon
dfcar <- apply(dfcar,1:2, function(x) as.character(x))
dfcar <- as.data.frame(dfcar)



#dcast will sort by alphabet --> create sort variable for later sorting
#http://seananderson.ca/2013/10/19/reshape.html
dfcast <- dcast(dfcar, sort ~ int, value.var="days")
dfcast <- dfcast[order(dfcast$years, dfcast$sort),] #sort by month instead of by alphabet
rownames(dfcast) <- dfcast$int
drops <- colnames(dfcast) %in% c("int", "years", "months", "sort")
dfcast <- dfcast[,!drops]
overview <- t(dfcast)
overview <- as.data.frame(overview)
View(overview)
colnames(overview)[!grepl("January", names(overview))] <- gsub('([A-z]+) .*', '\\1', colnames(overview))[!grepl("January", names(overview))]
## weekends in overview
wknds <- apply(overview, 1:2, function(x) grepl("(Sat)|(Sun)", x))
###
d <- 1:ncol(overview)
max <- 6
x <- seq_along(d)
d1 <- split(d, ceiling(x/max))
monthc <- NULL
for (i in d1) monthc <- c(monthc, knit_child('calendarChildOverview.Rnw'))