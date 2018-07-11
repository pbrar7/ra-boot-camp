# Install and load RMariaDB package
install.packages("RMariaDB")
library(RMariaDB)

#Use dbConnect to construct connection information
con <- dbConnect(RMariaDB::MariaDB(), dbname='test', user = "root", password = "root2018")

# Look at con
con

# Look at what objects exist at connection
dbListObjects(con)

# Wcich of those objects are tables?
dbListTables(con)

# Another way to check if the tables you're looking for exists
dbExistsTable(con, "YT_2017_06_Validated")

# Send query to MariaDB, retrieve results, and clear the result set, all in one step
dbGetQuery(con, 'SELECT * FROM YT_2017_06_Validated LIMIT 5')

# Send query to pull requests in batches
res <- dbSendQuery(con, 'SELECT id, tpep_pickup_datetime, tpep_dropoff_datetime FROM YT_2017_06_Validated')

# Retrieve results with dbFetch()
data <- dbFetch(res)

# Take a quick look to see what you retrieved
head(data,1)

# Clear the result on the MariaDB server
dbClearResult(res)

# Let's turn pickup an dropoff times into trip length
data$mins <- with(data, difftime(tpep_dropoff_datetime,tpep_pickup_datetime,units="mins") )
head(data,1)

# Drop everything from the working data frame except id and length
YT_2017_06_Length <- within(data, rm(tpep_dropoff_datetime,tpep_pickup_datetime))
head(YT_2017_06_Length)

# Push the table to the MariaDB server (will take a while)
dbWriteTable(con,"YT_2017_06_Length",YT_2017_06_Length)

# Sample query to combine data from two tables on server....

data2 <- dbGetQuery(con, 'SELECT YT_2017_06_validated.id, tip_amount,mins FROM YT_2017_06_validated JOIN YT_2017_06_length
                    on YT_2017_06_validated.id = YT_2017_06_length.id')
View(data2)



