install.packages(RMariaDB)
library(RMariaDB)

con <- dbConnect(RMariaDB::MariaDB(), dbname='test', user = "root", password = "root2018")
dbListTables(con)

dbListObjects(con)

dbExistsTable(con, "yellow_tripdata_2017_06")

dbGetQuery(con, 'SELECT * FROM yellow_tripdata_2017_06 LIMIT 5')

# Send query to pull requests in batches
res <- dbSendQuery(con, 'SELECT tpep_pickup_datetime, tpep_dropoff_datetime FROM yellow_tripdata_2017_06')
data <- dbFetch(res)
View(data)
dbClearResult(res)

data$mins <- with(data, difftime(tpep_dropoff_datetime,tpep_pickup_datetime,units="mins") )
View(data)

load("YT_2017_06_Validated.RData")

dbWriteTable(con,"YT_2017_06_Validated",YT_2017_06_Validated)
