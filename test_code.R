start <- "01.07.2015" # any date around which the agenda should begin (dd.mm.yyyy)
monthly_pages <- 3 # number of pages for the monthly overview (1 page = 6 months)


################################################################################
## Set-Up, packages, and custom functions ######################################
################################################################################
invisible(Sys.setlocale("LC_ALL","English"))

library(dplyr)
library(reshape2)
library(lubridate)

# from Hadley's comment on http://stackoverflow.com/a/6669237/4798582: 
safe.ifelse <- function(cond, yes, no) {
  structure(ifelse(cond, yes, no), class = class(yes))
}

# prevbestmonday returns next best Monday 
# (in the past if day unequal to Monday,
#  therefore the name: prev(ious) best monday)
prevbestmonday <- function(day)   { #requires lubridate
  # logic for safe.ifelse statement (custom function by Hadley):
  #   2 --> -0 already Mon   
  #   3 --> -1 #Tue
  #   4 --> -2 #Wed
  #   5 --> -3 #Thu
  #   6 --> -4 #Fri
  #   7 --> -5 #Sat
  #   
  #   1 --> -6 #Sun
  Mo <- safe.ifelse(wday(day) == 1, day - days(6),  #Monday
                    day - days( wday(day)-2 ))  #other days
  Mo <- paste(day(Mo), month(Mo), year(Mo), sep=".")
  Mo <- dmy(Mo)
  Mo
}


# nextbestsunday returns next best Sunday 
# (in the future if day unequal to Sunday)
nextbestsunday <- function(day)   { #requires lubridate
  # logic for safe.ifelse statement (custom function by Hadley):
  #   2 --> +6# Mon  
  #   3 --> +5 #Tue
  #   4 --> +4 #Wed
  #   5 --> +3 #Thu
  #   6 --> +2 #Fri
  #   7 --> +1 #Sat
  #   
  #   1 #already Sun
  Sun <- safe.ifelse( wday(day) == 1, day, #Sunday
                      day + (days(8) - days( wday(day))))  #other days
  Sun <- paste(day(Sun), month(Sun), year(Sun), sep=".")
  Sun <- dmy(Sun)
  Sun 
}


################################################################################
## Calculating start and end dates #############################################
################################################################################
# Convert start into date and extract year and month 
start <- dmy(start)
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
weekly_start <- prevbestmonday(start)
weekly_end <- nextbestsunday(monthly_end) 


################################################################################
## Calculating the dates for the weekly overview ###############################
################################################################################
weekly_range <- seq(weekly_start, weekly_end, "days")
weekly_dates <- format(weekly_range, "%d.%m") #31.01
weekly_days <- format(weekly_range, "%A")     #Monday
weekly_weeks <- format(weekly_range,"%W") #1
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
monthly_range <- seq(monthly_start, monthly_end, "days") 
monthly_dates <- format(monthly_range, "%d")    #31 #delete
monthly_days <- format(monthly_range, "%a")     #Mon  #delete?
monthly_wknds <- ifelse(wday(monthly_range) %in% c(7,1), TRUE, FALSE)  #weekends #delete
monthly_weeks <- format(monthly_range,"%W") #1
monthly_months <- format(monthly_range, "%B")   #January
monthly_years <- format(monthly_range, "%Y")    #2015
#----------------------------------------------------------
monthly_daywday <- format(monthly_range, "%d %a")
monthly_monthyear <- format(monthly_range, "%B %Y")
monthly_df <- data.frame(monthly_dates, 
                         monthly_days, 
                         monthly_weeks, 
                         monthly_months, 
                         monthly_years,
                         monthly_daywday,
                         monthly_monthyear,
                         monthly_wknds)
# remove monthly_ from column names
colnames(monthly_df) <- gsub(".*\\_","",colnames(monthly_df)) 


################################################################################
## Creating the monthly overview ###############################################
################################################################################
overview <- dcast(monthly_df, dates ~ monthyear, value.var="daywday")
overview <- overview[,-1] #remove dates variable after casting

#Sort columns for display
overview_names <- dmy(paste("01",names(overview)))
overview_names <- sort(overview_names)
overview_names <- format(overview_names, "%B %Y")
overview <- overview[factor(overview_names)]
#setcolorder(setDT(overview), overview_names) #requires (data.table)

# Remove year from column names, except for Januaries
colnames(overview)[!grepl("January", names(overview))] <- gsub('([A-z]+) .*', '\\1', colnames(overview))[!grepl("January", names(overview))]

## Weekends in overview
wknds <- apply(overview, 1:2, function(x) grepl("(Sat)|(Sun)", x))