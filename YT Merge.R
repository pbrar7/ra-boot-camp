yt_master <- read.csv("C:/Temp/yellow_tripdata_2017-06.csv", comment.char="#")
yellow_tripdata_2017_07 <- read.csv("C:/Temp/yellow_tripdata_2017-07.csv", comment.char="#")
yt_master <- rbind(yt_master, yellow_tripdata_2017_07)

# Getting rid of individual monthly files

rm(list=setdiff(ls(), "yt_master"))

# Note: "install" will throw warning errors if a package has been previously ignored
# install.packages("validate")

# Load "validate" package into active memory
library(validate)

# Let's examine yt_master to remind us what's in it...
names(yt_master)

# Let's add a new variable with sequential IDs for each row
yt_master$id<-seq.int(nrow(yt_master))

# attach() will place the data frame name into the search path, meaning that
# for many functions we can dispense with using the whole data frame name.
attach(yt_master)

v1<-validator(trip_distance<1000)
cf1<-confront(yt_master,v1,key="id")
out1<-as.data.frame(cf1)
names(out1)[3]<-"TD.LT.1000"
yt_validated_master <- merge(out1,yt_master, by.x="id",by.y="id")
yt_validated_master <- subset(yt_validated_master,select=-c(name,expression))
rm(v1, cf1, out1)

v1<-validator(total_amount>0)
cf1<-confront(yt_master,v1,key="id")
out1<-as.data.frame(cf1)
names(out1)[3]<-"AMT.GT.0"
yt_validated_master <- merge(out1,yt_validated_master, by.x="id",by.y="id")
yt_validated_master <- subset(yt_validated_master,select=-c(name,expression))
rm(v1, cf1, out1)


v1<-validator(trip_distance>0)
cf1<-confront(yt_master,v1,key="id")
out1 <- as.data.frame(cf1)
names(out1)[3]<-"TD.GT.0"
yt_validated_master <- merge(out1,yt_validated_master, by.x="id",by.y="id")
yt_validated_master <- subset(yt_validated_master,select=-c(name,expression))
rm(v1, cf1, out1)

# View(yt_validated_master)
str(yt_validated_master)

# install.packages("RMariaDB")
library(RMariaDB)


#Use dbConnect to construct connection information
con <- dbConnect(RMariaDB::MariaDB(), dbname='test', user = "root", password = "root2018")

dbWriteTable(con,"yt_validated_master",yt_validated_master)

yt_duration = subset(yt_validated_master, select = c(id, tpep_dropoff_datetime,tpep_pickup_datetime) )

rm(yt_validated_master)

# Let's turn pickup and dropoff times into trip duration
yt_duration$mins <- with(yt_duration, difftime(tpep_dropoff_datetime,tpep_pickup_datetime,units="mins") )
head(yt_duration,1)

# Drop everything except id and length
yt_duration <- within(yt_duration, rm(tpep_dropoff_datetime,tpep_pickup_datetime))

dbWriteTable(con,"yt_duration",yt_vduration)


