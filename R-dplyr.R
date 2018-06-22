install.packages("validate")
library(validate)
?validate()
View(Yellow_Tripdata_2017_06)
str(Yellow_Tripdata_2017_06)
Yellow_Tripdata_2017_06$id<-seq.int(nrow(Yellow_Tripdata_2017_06))
str(Yellow_Tripdata_2017_06)
cf <- check_that(Yellow_Tripdata_2017_06, trip_distance < 1000)
cf
summary(cf)
barplot(cf,main="Checks on the Yellow_Tripdata_2017_06 data set")
v <-  validator(Yellow_Tripdata_2017_06[[5]] < 1000)
v
cf <- confront(Yellow_Tripdata_2017_06,v,key="id")
(out <- as.data.frame(cf))
YT_2017_06_Validated <- merge(out,Yellow_Tripdata_2017_06)
summary(cf)
attach(Yellow_Tripdata_2017_06)
v <- validator(speed:=trip_distance/(tpep_dropoff_datetime-tpep_pickup_datetime),speed<60)
v
cf <- confront(Yellow_Tripdata_2017_06,v)
cf
summary(cf)
Yellow_Tripdata_2017_06$tpep_dropoff_datetime <- as.POSIXct(Yellow_Tripdata_2017_06$tpep_dropoff_datetime,
                                    format='%Y-%m-%d %H:%M')
Yellow_Tripdata_2017_06$tpep_pickup_datetime <- as.POSIXct(Yellow_Tripdata_2017_06$tpep_pickup_datetime,
                                    format='%Y-%m-%d %H:%M')
View(Yellow_Tripdata_2017_06)
str(Yellow_Tripdata_2017_06)

install.packages("dplyr")
library(dplyr)
workdata <- mutate(Yellow_Tripdata_2017_06,trip_length=(tpep_dropoff_datetime-tpep_pickup_datetime)/60)
workdata$trip_length <- as.integer(workdata$trip_length)
workdata <- mutate(workdata,trip_speed=trip_distance*60/trip_length)

View(workdata)       
