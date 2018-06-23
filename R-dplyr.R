install.packages("dplyr")
library(dplyr)
DF <- read.csv("PakistanSuicideAttacks Ver 11 (30-November-2017).csv")
View(DF)
names(DF)
attach(DF)

# dplyr function distinct_
DF_deduped <- distinct_(DF,"Date","Time","Latitude","Longitude",.keep_all=TRUE)
View(DF_deduped)

# distinct_() using pipes...
DF_deduped <- DF %>% distinct_("Date","Time","Latitude","Longitude",.keep_all=TRUE)
View(DF_deduped)

# Using mutate() to do find and replace
DF_replaced <- mutate(DF_deduped,Time=replace(Time,Time=="N/A",NA))
View(DF_replaced)

# Replacing multiple variables/instances 
DF_replaced <- mutate(DF_deduped,Time=replace(Time,Time=="N/A",NA),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="shiite","Shiite"),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="sunni","Sunni"),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="None",NA),
                      Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="",NA))
View(DF_replaced)

# So now pipes start to make sense
DF_replaced <- DF %>% distinct_("Date","Time","Latitude","Longitude",.keep_all=TRUE) %>% 
  mutate(Time=replace(Time,Time=="N/A",NA),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="shiite","Shiite"),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="sunni","Sunni"),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="None",NA),
         Targeted.Sect.if.any=replace(Targeted.Sect.if.any,Targeted.Sect.if.any=="",NA))
View(DF_replaced)

# One way to  capitalize is override regular expression usage and pass a Perl expression...
DF_capped <- DF_replaced %>%
  mutate(City = sub("(.)", "\\U\\1", City, perl=TRUE))
View(DF_capped)

# But we are using a program that allows us to cherry-pick functions from different packages
install.packages("R.utils")
library(R.utils)
DF_capped <- DF_replaced %>% mutate(City = capitalize(City))
View(DF_capped)

