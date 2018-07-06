# Install and load Rcmdr package
install.packages("Rcmdr")
library(Rcmdr)

# Install and load RMariaDB package
install.packages("RMariaDB")
library(RMariaDB)

#Use dbConnect to construct connection information
con <- dbConnect(RMariaDB::MariaDB(), dbname='test', user = "root", password = "root2018")

# Which tables?
dbListTables(con)

# Send query to MariaDB, retrieve results, and clear the result set, all in one step
sample <- dbGetQuery(con, 'SELECT * FROM YT_VALIDATED_5PCT')
