# Load the previously referenced data frame in "Yellow_Tripdata_2017_06.RData"
// Tototally unneedful edit
load("Yellow_Tripdata_2017_06.RData")

# Note: "install" will throw warning errors if a package has been previously ignored
install.packages("validate")

# Load "validate" package into active memory
library(validate)

# Let's examine Yellow_Tripdata_2017_06 to remind us what's in it...
View(Yellow_Tripdata_2017_06)
names(Yellow_Tripdata_2017_06)

# Let's add a new variable with sequential IDs for each row
Yellow_Tripdata_2017_06$id<-seq.int(nrow(Yellow_Tripdata_2017_06))

# Now we'll check to see that the new "id" variable has been added...
names(Yellow_Tripdata_2017_06)

# Trick to list column names, numbered and vertically
as.data.frame(colnames(Yellow_Tripdata_2017_06))

# attach() will place the data frame name into the search path, meaning that
# for many functions we can dispense with using the whole data frame name.
attach(Yellow_Tripdata_2017_06)

# Now we can actually start using the validate package.
# validator() will take desired rules as inputs...
v <-  validator( trip_distance<1000,total_amount>0,trip_distance>0)
v

# Now, we "confront()" our data with that set of rules, specifying our unique key
cf <- confront(Yellow_Tripdata_2017_06,v,key="id")
cf

# Let's put the cf into a data frame object to see fi we can see more about it...
out <- as.data.frame(cf)
View(out)

# If we merge this with the original data, will get >28.9M rows...why?
# So, alternate way to wind up with a tractable data set...
# (Note: we'll see a much better way to handle this with the dplyr() package later)

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
# We'll start with "out1"....
YT_2017_06_Validated <- merge(out1,Yellow_Tripdata_2017_06, by.x="id",by.y="id")
# " ... and we'll use "subset" to drop "name" and "expression"...
YT_2017_06_Validated <- subset(YT_2017_06_Validated,select=-c(name,expression))

# Next, merge "out2" into our (working) merged data frame, YT_2016_06_Validated....
YT_2017_06_Validated <- merge(out2,YT_2017_06_Validated, by.x="id",by.y="id")
YT_2017_06_Validated <- subset(YT_2017_06_Validated,select=-c(name,expression))

# Finally, merge "out3" into our (working) merged data frame, YT_2016_06_Validated....
YT_2017_06_Validated <- merge(out3,YT_2017_06_Validated, by.x="id",by.y="id")
YT_2017_06_Validated <- subset(YT_2017_06_Validated,select=-c(name,expression))

# And let's take a look at what it looks like:
View(YT_2017_06_Validated)
str(YT_2017_06_Validated)

# Finally, save our validated data set for the next module...
save(YT_2017_06_Validated,file="YT_2017_06_Validated.RData")

YT_2017_06_Validated<-YT_2017_06_Validated[which(YT_2017_06_Validated$TD.GT.0 == T & YT_2017_06_Validated$AM.GT.0 == T & YT_2017_06_Validated$TD.LT.1000 == T),]

