library(dplyr)
# library(ggplot2)

# no matches when they are inner-joined:
DF_2bjoined <- DF_cleaned

DF_joined <- left(DF_cleaned, pk, by = c(City = "city"))

# install.packages("fuzzyjoin")
library(fuzzyjoin)


# but we can match when they're fuzzy joined
DF_fuzzyjoined <- stringdist_left_join(DF_cleaned,pk, by = c(City = "city"), max_dist =3)

DF_joined <- mutate(DF_joined, city=as.factor(" "))
DF_joined<-DF_joined[which(DF_joined$population>1),]
DF_fuzzyjoined<-DF_fuzzyjoined[which(DF_fuzzyjoined$population>1),]
str(DF_joined)
str(DF_fuzzyjoined)
Compare <- anti_join(DF_fuzzyjoined,DF_joined,by="S.")
View(select(Compare, S., City, city))

Compare <- right_join(DF_joined,DF_fuzzyjoined, by = c(S. = "S."))
str(Compare)
View(select(Compare, S., city.x, lat.x, lat.y))

     