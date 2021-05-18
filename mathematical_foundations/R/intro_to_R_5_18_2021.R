library(tidyverse)
library(lubridate)

# Pull in data ----

births_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data<-read_csv(url(births_url))

# warm up, using the births_data df, 
# create a new data frame grouping by year and find the mean, median, sum, max, and min for each year. 


################################################
#
# 1. Demonstration of Random sampling and CI in R: ---- 
#
############################################### 

births_100 <- sample_n(births_data, 
                       100)
x<-mean(births_100$births, 
        na.rm=T)

n<-nrow(births_100)

st_dev<-sd(births_100$births, 
           na.rm=T)

# Create a function for confidence interval ----

ci_function<- function(x, interval, n, st_dev) {
  
  # Function parameters 
  # ------------------------------------------------
  # x = sample mean
  # interval is the CI interval you would like to see
  # n is the sample size
  # st_dev us the sample standard deviation
  
  bottom<- x - ((interval*st_dev)/sqrt(n))
  
  top <- x + ((interval*st_dev)/sqrt(n))
  
  print(paste0('The mean of the sample is ', 
         format(x, big.mark=','), 
         ' with a CI between ', 
         format(bottom, big.mark=','), 
         ' and ', 
         format(top, big.mark=','), 
         '.')
        )
}

ci_function(x, 1.96, n, st_dev)

