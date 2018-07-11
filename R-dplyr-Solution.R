# installpackages("dplyr")
library(dplyr)
DF <- read.csv("PakistanSuicideAttacks Ver 11 (30-November-2017).csv")
# View(DF)
str(DF)
names(DF)
# attach(DF)

# dplyr function distinct_
DF_deduped <- distinct_(DF,"Date","Time","Latitude","Longitude",.keep_all=TRUE)
# View(DF_deduped)

# distinct_() using pipes...
DF_deduped <- DF %>% distinct_("Date","Time","Latitude","Longitude",.keep_all=TRUE)
# View(DF_deduped)

# Using mutate() to do find and replace
DF_replaced <- mutate(DF_deduped,Time=replace(Time,Time=="N/A",NA))
# View(DF_replaced)

# Replacing multiple variables/instances 
DF_replaced <- mutate(DF_deduped,Time=replace(Time,Time=="N/A",NA),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="shiite","Shiite"),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="sunni","Sunni"),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="None",NA),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="",NA))
# View(DF_replaced)

# So now pipes start to make sense
DF_replaced <- DF %>% distinct_("Date","Time","Latitude","Longitude",.keep_all=TRUE) %>% 
  mutate(Time=replace(Time,Time=="N/A",NA),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="shiite","Shiite"),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="sunni","Sunni"),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="None",NA),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="",NA))
# View(DF_replaced)

# One way to  capitalize is override regular expression usage and pass a Perl expression...
DF_capped <- DF_replaced %>%
  mutate(City = sub("(.)", "\\U\\1", City, perl=TRUE))
# View(DF_capped)

# But we are using a program that allows us to cherry-pick functions from different packages
# installpackages("R.utils")
library(R.utils)
DF_capped <- DF_replaced %>% mutate(City = capitalize(City))

# View(DF_capped)

str(DF_capped)
is.numeric(DF_capped$Temperature.F.)

# Cleaning up Date
# Will use separate() function from tidyr
# installpackages("tidyr")
library(tidyr)

# Split the Day of the Week and the Date
DF1 <- DF_capped %>% separate(col=Date,into=c("Day of Week", "Date"),"-",extra="merge")
# View(DF1)

#Extract the Year
DF2 <- DF1 %>% mutate(Year=substr(Date, nchar(Date)-3, nchar(Date)),Date=substr(Date,1,nchar(Date)-5))
# View(DF2)

# Standardize the "Month-Day" portion by substituting blanks for dashes
DF2$Date <- gsub("-", " ", DF2$Date)
# View(DF2)

# Split the Month and the Day
DF3 <- DF2 %>% separate(col=Date,into=c("Month", "Day")," ",extra="merge")
# View(DF3)

# Replace alpha Month with Month Number
DF4 <- DF3 %>% mutate(Month=replace(Month,Month=="Jan",1),
                      Month=replace(Month,Month=="Feb",2),
                      Month=replace(Month,Month=="Mar",3),
                      Month=replace(Month,Month=="Apr",4),
                      Month=replace(Month,Month=="May",5),
                      Month=replace(Month,Month=="Jun",6),
                      Month=replace(Month,Month=="Jul",7),
                      Month=replace(Month,Month=="Aug",8),
                      Month=replace(Month,Month=="Sep",9),
                      Month=replace(Month,Month=="Oct",10),
                      Month=replace(Month,Month=="Nov",11),
                      Month=replace(Month,Month=="Dec",12),
                      Month=replace(Month,Month=="January",1),
                      Month=replace(Month,Month=="February",2),
                      Month=replace(Month,Month=="March",3),
                      Month=replace(Month,Month=="April",4),
                      Month=replace(Month,Month=="May",5),
                      Month=replace(Month,Month=="June",6),
                      Month=replace(Month,Month=="July",7),
                      Month=replace(Month,Month=="August",8),
                      Month=replace(Month,Month=="September",9),
                      Month=replace(Month,Month=="October",10),
                      Month=replace(Month,Month=="November",11),
                      Month=replace(Month,Month=="December",12))
                      
# View(DF4)
str(DF4)

# Re-order the columns to get the Date fields back together and to re-title some of the titles
DF5 = DF4 %>% select(S., "Day of Week", Day, Month, Year, Islamic.Date, Blast.Day.Type, Holiday.Type,
                     Time, City, Latitude, Longitude, Province, Location, Location.Category,
                     Location.Sensitivity,Open.Closed.Space, Influencing.Event.Event,
                     Target.Type, "Target.Sect.If.Any"=Targeted.Sect.if.any, Killed.Min, Killed.Max,
                     Injured.Min, Injured.Max, "No.of.Suicide.Blasts"=No..of.Suicide.Blasts,
                     "Explosive.Weight.Max"=Explosive.Weight..max.,Hospital.Names, 
                     "Temperature.C"=Temperature.C., "Temperature.F"=Temperature.F.)
# View(DF5)
str(DF5)

# Let's convert the Month, Day, and Year into numeric variables...
DF6 <- DF5 %>% mutate_at(c(3,4,5), as.numeric)
# View(DF6)
str(DF6)

# ...so that we can add an actual "Date" variable
DF7 = DF6 %>% mutate(Date=ISOdate(Year,Month,Day))
# View(DF7)
str(DF7)
# Using pipes to do most of the last bit at once...
DF_cleaned <- DF2 %>% separate(col=Date,into=c("Month", "Day")," ",extra="merge") %>% 
              mutate(Month=replace(Month,Month=="Jan",1),
                     Month=replace(Month,Month=="Feb",2),
                     Month=replace(Month,Month=="Mar",3),
                     Month=replace(Month,Month=="Apr",4),
                     Month=replace(Month,Month=="May",5),
                     Month=replace(Month,Month=="Jun",6),
                     Month=replace(Month,Month=="Jul",7),
                     Month=replace(Month,Month=="Aug",8),
                     Month=replace(Month,Month=="Sep",9),
                     Month=replace(Month,Month=="Oct",10),
                     Month=replace(Month,Month=="Nov",11),
                     Month=replace(Month,Month=="Dec",12),
                     Month=replace(Month,Month=="January",1),
                     Month=replace(Month,Month=="February",2),
                     Month=replace(Month,Month=="March",3),
                     Month=replace(Month,Month=="April",4),
                     Month=replace(Month,Month=="May",5),
                     Month=replace(Month,Month=="June",6),
                     Month=replace(Month,Month=="July",7),
                     Month=replace(Month,Month=="August",8),
                     Month=replace(Month,Month=="September",9),
                     Month=replace(Month,Month=="October",10),
                     Month=replace(Month,Month=="November",11),
                     Month=replace(Month,Month=="December",12)) %>% 
            select(S., "Day of Week", Day, Month, Year, Islamic.Date, Blast.Day.Type, Holiday.Type,
                  Time, City, Latitude, Longitude, Province, Location, Location.Category,
                  Location.Sensitivity,Open.Closed.Space, Influencing.Event.Event,
                  Target.Type, "Target.Sect.If.Any"=Targeted.Sect.if.any, Killed.Min, Killed.Max,
                  Injured.Min, Injured.Max, "No.of.Suicide.Blasts"=No..of.Suicide.Blasts,
                  "Explosive.Weight.Max"=Explosive.Weight..max.,Hospital.Names, 
                  "Temperature.C"=Temperature.C., "Temperature.F"=Temperature.F.) %>%
            mutate_at(c(3,4,5), as.numeric) %>%
            mutate(Date=ISOdate(Year,Month,Day)) 
# View(DF_cleaned)

# Using filter()
DF_holidays <- DF_cleaned %>% filter(Blast.Day.Type=="Holiday")
# View(DF_holidays)

# Using arrange()
DF_sorted <- DF_cleaned %>% arrange(Target.Type,desc(Injured.Max))
# View(DF_sorted)

# To convert Injured.Max to numeric...
str(DF_cleaned)
DF_cleaned <- DF_cleaned %>% mutate_at(c(11,12,21,22,23,24,25), as.numeric)
str(DF_cleaned)

# Rerunning the sort...
DF_sorted <- DF_cleaned %>% arrange(Target.Type,desc(Injured.Max))
# View(DF_sorted)

# Using summarise()
DF_cleaned %>% group_by(Target.Type) %>% 
summarise(mean=mean(Injured.Max), n=n())

# Using sample_n() and sample_frac()
SampleN <- sample_n(DF_cleaned, 20)
# View(SampleN)
SampleP <- sample_frac(DF_cleaned, .1)
# View(SampleP)

# Getting rid of all our intermediate results DFs

rm(list=setdiff(ls(), "DF_cleaned"))

# Convert latitude and longitude to numeric with 4 decimal places
# 
# No need: just change digits displayed:
options(digits = 6)
View(select(DF_cleaned, Latitude, Longitude))


# Convert Blast.Day.Type to binary variable where 0 = Working Day and 1 = Holiday

DF_cleaned$Blast.Day.Type <- ifelse(DF_cleaned$Blast.Day.Type=="Holiday", 1, ifelse(DF_cleaned$Blast.Day.Type=="Working Day", 0, NA))
View(DF_cleaned)
str(DF_cleaned)

# Sort in ascending date order and compute days since last bombing

# Using arrange()to sort by Target.Type and desc(Injured.Max) to show that lag() sorts for itself
DF_cleaned <- DF_cleaned %>% arrange(Target.Type,desc(Injured.Max))

# Using arrange() with lag() to demonstrate lag()
DF_cleaned <- DF_cleaned %>% mutate("Days Since Last Bombing"=(Date-lag(Date, order_by = Date))/86400)


                                    