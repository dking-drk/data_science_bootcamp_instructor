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

ci_function_base<- function(x, interval, n, st_dev) {
  
  # Function parameters 
  # ------------------------------------------------
  # x = sample mean
  # interval is the CI interval you would like to see
  # n is the sample size
  # st_dev us the sample standard deviation
  
  bottom<- x - ((interval*st_dev)/sqrt(n))
  
  top<- x + ((interval*st_dev)/sqrt(n))
  
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

################################################
#
# 2. Creating a Loop for to Demo Confidence Interval: ---- 
#
############################################### 

# First, I am going to adjust the function above. 

ci_function_pro<- function(x, interval, n, st_dev) {
  
  # Function parameters 
  # ------------------------------------------------
  # x = sample mean
  # interval is the CI interval you would like to see
  # n is the sample size
  # st_dev us the sample standard deviation
  
  bottom<- x - ((interval*st_dev)/sqrt(n))
  
  top<- x + ((interval*st_dev)/sqrt(n))
  
  data.frame(sample_size=n, 
                mean=x, 
                upper_ci=top, 
                bottom_ci=bottom) %>% 
    gather('bound', 
           'confidence', 
           3:4)
  
}

# Create a blank data frame

shrinking_interval<-data.frame()

# Loop through many iterations of sample sizes to see CI shrink

for(i in 30:3000) {
  
  # Identify parameters 
  
  births_ci <- sample_n(births_data, 
                         i)
  x<-mean(births_ci$births, 
          na.rm=T)
  
  n<-nrow(births_ci)
  
  st_dev<-sd(births_ci$births, 
             na.rm=T)
  
  # Create data frame
  
  shrinking_interval <- shrinking_interval %>% 
    bind_rows(ci_function(x, 1.96, n=i, st_dev) )
    
}

ggplot(shrinking_interval, aes(x=sample_size, y=confidence, color=bound)) + 
  geom_line(size=1.5) + 
  geom_hline(yintercept=mean(births_data$births, 
                  na.rm=T), 
             linetype="dashed", 
             color = "black") +
  labs(title='Confidence Intervals for Radom Selections of Births in a Day', 
       x='Sample Size', 
       y='Confidence Interval', 
       color='Bounds')

################################################
#
# 3. Choosing a Target Confidence Interval: ---- 
#
############################################### 

births_100 <- sample_n(births_data, 
                       100)
x<-mean(births_100$births, 
        na.rm=T)

n<-nrow(births_100)

st_dev<-sd(births_100$births, 
           na.rm=T)

# I want a CI of 1000 Births

sample_size<- 2*(st_dev/(sqrt(1000)))#figured st_dev in line 27 of this code

true_mean<-mean(births_data$births, 
     na.rm=T)

ci_function_base(x, 1.96, sample_size, st_dev)

ggplot(shrinking_interval, aes(x=sample_size, y=confidence, color=bound)) + 
  geom_line(size=1.5) + 
  geom_hline(yintercept=mean(births_data$births, 
                             na.rm=T), 
             linetype="dashed", 
             color = "black") +
  geom_vline(xintercept=sample_size, 
             linetype="dashed", 
             color = "black") +
  labs(title='Confidence Intervals for Radom Selections of Births in a Day', 
       x='Sample Size', 
       y='Confidence Interval', 
       color='Bounds')



ggplot(births_data, aes(births)) +
  geom_histogram()






