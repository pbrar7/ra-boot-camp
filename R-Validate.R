install.packages("validate")
library(validate)
?validate()
View(Yellow_Tripdata_2017_06)
names(Yellow_Tripdata_2017_06)
# To add a new variable with sequential IDs
Yellow_Tripdata_2017_06$id<-seq.int(nrow(Yellow_Tripdata_2017_06))
#
names(Yellow_Tripdata_2017_06)
# Trick to list column names, numbered and vertically
c<-colnames(Yellow_Tripdata_2017_06)
as.data.frame(c)
# attach() will place the data frame name into the search path, meaning that
# for many functions can dispense with using the whole data frame name.
attach(Yellow_Tripdata_2017_06)
#
v <-  validator( trip_distance<1000,total_amount>0,trip_distance>0)
v

cf <- confront(Yellow_Tripdata_2017_06,v,key="id")
cf
out <- as.data.frame(cf)
View(out)
# If we merge this with the original data, will get >28.9M rows...why?
# So, alternate way to wind up with a tractable data set
v1<-validator(trip_distance<1000)
v1
cf1<-confront(Yellow_Tripdata_2017_06,v1,key="id")
cf1
out1<-as.data.frame(cf1)
View(out1)

v2<-validator(total_amount>0)
v2
cf2<-confront(Yellow_Tripdata_2017_06,v2,key="id")
cf2
out2<-as.data.frame(cf2)
View(out2)

v3<-validator(trip_distance>0)
v3
cf3<-confront(Yellow_Tripdata_2017_06,v3,key="id")
cf3
out3 <- as.data.frame(cf3)
View(out3)

# Now, to keep each validation rule and result clear...
names(out1)
names(out1)[3]<-"TD.LT.1000"
names(out2)[3]<-"AMT.GT.0"
names(out3)[3]<-"TD.GT.0"
# Now to merge the results of the confrontation with Yellow_Tripdata_2016_06
YT_2017_06_Validated <- merge(out1,Yellow_Tripdata_2017_06, by.x="id",by.y="id")
YT_2017_06_Validated <- subset(YT_2017_06_Validated,select=-c(name,expression))

YT_2017_06_Validated <- merge(out2,YT_2017_06_Validated, by.x="id",by.y="id")
YT_2017_06_Validated <- subset(YT_2017_06_Validated,select=-c(name,expression))

YT_2017_06_Validated <- merge(out3,YT_2017_06_Validated, by.x="id",by.y="id")
YT_2017_06_Validated <- subset(YT_2017_06_Validated,select=-c(name,expression))

View(YT_2017_06_Validated)
str(YT_2017_06_Validated)
