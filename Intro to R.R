# R script to accopany Intro to R
#######################################################
# Assignment Examples
# Numeric
x = 7
y <- 8
#
# Character
#
Name <- "Troy"
#
# Logical
#
CheckFlag <- T
#
#Date 
DateTime <- date()
Date <- Sys.Date()
# use as.Date( ) to convert strings to dates
mydates <- as.Date(c("2007-06-22", "2004-02-13"))
mydates
# number of days between 6/22/07 and 2/13/04
days <- mydates[1] - mydates[2]
days
#
# Operators
#
z <- X + y
# The preceeding will return an error becuase X <> x
z1 <- x + y
z1
z2 <- x - y
z2
z3 <- x * y
z3
z4 <- x / y
z4
z5 <- x ** y
z5
z6 <- x ^ y
z6

