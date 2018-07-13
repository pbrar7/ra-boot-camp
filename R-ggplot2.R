# Install and load ggplot2 package
install.packages("ggplot2")
library(ggplot2)

data(diamonds)
summary(diamonds)
dim(diamonds)

plot (price ~ carat, data=diamonds)
plot(diamonds$carat, diamonds$price)
boxplot(diamonds$carat)

hist(diamonds$carat)
hist(diamonds$carat, main="Carat Histogram", xlab="Carat")

ggplot(data = diamonds)
ggplot(data = diamonds)+geom_histogram(aes(x=carat))
ggplot(data = diamonds)+geom_density(aes(x=carat),fill='grey50')


ls(pattern = '^geom_', env = as.environment('package:ggplot2'))


help(aes)
help(aes_colour_fill_alpha)
help(aes_group_order)
help(aes_linetype_size_shape)
help(aes_position)

ggplot(data=diamonds) + 
  geom_histogram(binwidth=500, aes(x=diamonds$price)) + 
  ggtitle("Diamond Price Distribution") + 
  xlab("Diamond Price U$") + 
  ylab("Frequency") + 
  theme_minimal()

summary(diamonds$price)

ggplot(data=diamonds) + 
  geom_histogram(binwidth=500, aes(x=diamonds$price)) + 
  ggtitle("Diamond Price Distribution") + 
  xlab("Diamond Price U$ - Binwidth 500") + 
  ylab("Frequency") + 
  theme_minimal() + 
  xlim(0,2500)

ggplot(data=diamonds) + 
  geom_histogram(binwidth=100, aes(x=diamonds$price)) + 
  ggtitle("Diamond Price Distribution") + 
  xlab("Diamond Price U$- Binwidth 50") + 
  ylab("Frequency") + 
  theme_minimal() + 
  xlim(0,2500)

ggplot(data=diamonds) + 
  geom_histogram(binwidth=100, aes(x=diamonds$price)) + 
  ggtitle("Diamond Price Distribution by Cut") + 
  xlab("Diamond Price U$") + 
  ylab("Frequency") + 
  theme_minimal() + 
  facet_wrap(~cut)

install.packages("ggplotgui")

# In order to install the most recent version of this package, you'll need to use the "devtools"-package
install.packages("devtools")
devtools::install_github("gertstulp/ggplotgui")

library("ggplotgui")

ggplot_shiny(diamonds)

df <- read.csv("yt_sample.csv", comment.char="#")

head(df,1)

library(lubridate)

df$hour <- hour(df$tpep_pickup_datetime)

df$shift <- ifelse(df$hour >= 4 & df$hour < 12, "01 Morning",
                    ifelse(df$hour >= 12 & df$hour < 18, "02 Afternoon",
                    ifelse(df$hour >= 18 & df$hour <= 23, "03 Evening", "04 Late Night")))

ggplot_shiny(df)

graph <- ggplot(df, aes(x = passenger_count, fill = shift)) +
  geom_histogram(position = 'identity', alpha = 0.48, binwidth = 2) +
  theme_bw()
graph

# If you want the plot to be interactive,
# you need the following package(s):
library("plotly")
ggplotly(graph)
