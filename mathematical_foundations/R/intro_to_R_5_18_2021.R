library(tidyverse)
library(lubridate)

# Pull in data ----

births_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data<-read_csv(url(births_url))

# warm up, using the births_data df, 
# create a new data frame grouping by year and find the mean, median, sum, max, and min for each year. 

births_year <- births_data %>% 
  group_by(year) %>% 
  summarize(median_births=median(births, na.rm=T))

ggplot(births_year, aes(x=year, y=median_births)) + 
  geom_line(size=1.5)


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

ci_function_base(x, 1.96, n, st_dev)


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

# For Loop through many iterations of sample sizes to see CI shrink

for(i in 30:3000) {
  
  # Identify parameters 
  
  births_ci <- sample_n(births_data, 
                         i)
  x<-mean(births_ci$births, 
          na.rm=T)
  
  n<-nrow(births_ci)
  
  st_dev<-sd(births_ci$births, 
             na.rm=T)
  
  print(i)
  
  # Create data frame
  
  shrinking_interval <- shrinking_interval %>% 
    bind_rows(ci_function_pro(x, 1.96, n=i, st_dev) )
    
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

# I want a CI of 1000 Births

births_100 <- sample_n(births_data, 
                       30)
x<-mean(births_100$births, 
        na.rm=T)

n<-nrow(births_100)

st_dev<-sd(births_100$births, 
           na.rm=T)

sample_size<- ((2*st_dev)/500)^2#figured st_dev in line 27 of this code

#### Run again with new interval 

births_new_sample <- sample_n(births_data, 
                       sample_size)

x<-mean(births_new_sample$births, 
        na.rm=T)

n<-nrow(births_new_sample)

st_dev<-sd(births_new_sample$births, 
           na.rm=T)

ci_function_base(x, 1.96, n, st_dev)

true_mean<-mean(births_data$births, 
     na.rm=T)



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

################################################
#
# 4. Hypothesis Test: ---- 
#
############################################### 

sample_median_hh_income<-read.csv('./mathematical_foundations/R/sample_median_hh_income.csv')

x=mean(sample_median_hh_income$median_hh_income, 
       na.rm=T)# mean

sd=sd(sample_median_hh_income$median_hh_income, 
      na.rm=T)# sd

n=nrow(sample_median_hh_income)# n

test_statistic<-(x-68000)/(sd/sqrt(n))

# Do we accept the null hypothesis?

if (abs(test_statistic) > 1.96) {
  print('We accept the null hypothesis.')
} else {
  print('We cannot accept the null hypothesis.')
}

################################################
#
# 5. One Sample T-Test: ---- 
#
############################################### 

t.test(sample_median_hh_income$median_hh_income, 
       mu=68000)

################################################
#
# 6. Two Student Sample T-Test: ---- 
#
############################################### 

ggplot(births_data, aes(x=births)) + 
  geom_histogram() + 
  labs(title='Births Per Day', 
       y='Total Days', 
       x='Total Births')

t_test_births_df <- births_data %>% 
  mutate(season=ifelse(month %in% c(1,2,3), 
                       'winter', 
                       ifelse(month %in% c(6,7,8), 
                              'summer', 
                              'other')
                       )
         ) %>% 
  filter(season!='other')

winter<-t_test_births_df %>% 
  filter(season!='winter')

summer<-t_test_births_df %>% 
  filter(season!='summer')

# Test for equal variance first 

var<-var.test(winter$births, summer$births)

if(var$p.value < .05) {
  var=F
} else { 
  var=T}

t.test(winter$births, summer$births, var.equal = var)

################################################
#
# 6. Two Student Sample T-Test: ---- 
#
############################################### 

# "campaign","conversions","clicks"
# desk_organization,72241.79036798535,57375642
# dirty_clothes,197403.74723294372,129139077


prop.test(x = c(72241.79036798535, 197403.74723294372), 
          n = c(57375642, 129139077))

################################################
#
# 7. Correlation: ---- 
#
############################################### 

git_grad='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

recent_grad_data<-read_csv(url(git_grad)) %>% 
  mutate(perc_low_wage=Low_wage_jobs/Employed)

ggplot(recent_grad_data, aes(x=ShareWomen, y=perc_low_wage)) + 
  geom_point() + 
  geom_smooth(method = 'lm') + 
  labs(title='The Relationship Between Share of Women Studying a Major and Post Graduate Low Wage Employment', 
       x='% of Women', 
       y='% Low Wage Employment')








