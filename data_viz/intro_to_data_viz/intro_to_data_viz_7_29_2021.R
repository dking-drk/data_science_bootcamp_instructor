library(tidyverse)
library(lubridate)
library(datasets)
options(scipen=999)

custom_theme <- theme(panel.background = element_rect(fill = "white"),
                      panel.grid.major = element_line(colour = "grey", size=0.5, linetype="dashed"),
                      panel.border = element_rect(fill=NA, color="grey", size=0.5, linetype="solid"),
                      plot.title=element_text(family="inherit", size = "13")
)

# Warm up! ----

births_raw_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

birth_data<-read.csv(url(births_raw_url)) %>%
  mutate(date=as.Date(paste0(year,
                             '-',
                             month,
                             '-',
                             date_of_month)
  ), 
  week=floor_date(date, 'week')
  )

# Create a line plot of births by day using the birth data data set. 

ggplot(birth_data, aes(x=date, y=births)) +
  geom_line()

################################
#
# Basic Vizualizations in GGplot ----
#
################################

# Time series plots ----

births_raw_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

birth_data<-read.csv(url(births_raw_url)) %>%
  mutate(date=as.Date(paste0(year,
                             '-',
                             month,
                             '-',
                             date_of_month)
  ), 
  week=floor_date(date, 'week')
  )

birth_data_week <- birth_data  %>% 
  group_by(week) %>% 
  summarize(births=sum(births, na.rm=T)) %>% 
  filter(week>as.Date('1999-12-26') & 
           week < as.Date('2014-12-28'))

ggplot(birth_data_week, aes(x=week, y=births)) + 
  geom_line(size=1.5) + 
  labs(title='US Births by Week 2000 - 2014', 
       x='Week', 
       y='Total Births')

# Try creating a plot but aggregating by year!

birth_data_year <- birth_data %>%
  group_by(year) %>% 
  summarize(births=sum(births, na.rm=T)) 

# Historgams ----

ggplot(birth_data, aes(x=births)) + 
  geom_histogram() + 
  labs(title='Histogram of Births by Day', 
       x='Total Births', 
       y='Count')

# Try creating a histogram for median income (median) using the recent_grad data frame below! ----

git_grad='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

recent_grad_data<-read.csv(url(git_grad))

# Scatter Plot ----

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median)) + 
  geom_point(size=1.5) + 
  labs(title='Scatter Plot for Share of Women and Median Income', 
       x='Share of Women', 
       y='Median income')

# Try creating a scatter plot between ShareWomen and Unemployment_rate! ----

# Smoothed Plot ----

ggplot(birth_data_week, aes(x=week, y=births)) + 
  geom_smooth() + 
  labs(title='US Births by Week 2000 - 2014', 
       x='Week', 
       y='Total Births')


# Try creating a smoother plot with the birth_data data frame where x = date and y = births! ----

################################
#
# Preparing Data for Visualization ----
#
################################

# 1. Adjusting Temporal Data ---- 

# week

birth_data_week <- birth_data %>% 
  group_by(week) %>% 
  summarize(births=sum(births, na.rm=T)
            )

ggplot(birth_data_week, aes(x=week, y=births)) + 
  geom_line() + 
  labs(title='US Births by Week 2000 - 2014', 
       x='Week', 
       y='Total Births')

# month

birth_data_month <- birth_data %>% 
  mutate(month=floor_date(date, 'month')) %>%
  group_by(month) %>% 
  summarize(births=sum(births, na.rm=T)
  )

ggplot(birth_data_month, aes(x=month, y=births)) + 
  geom_line() + 
  labs(title='US Births by Month 2000 - 2014', 
       x='Month', 
       y='Total Births')

# quarter

birth_data_q <- birth_data %>% 
  mutate(quarter=floor_date(date, 'quarter')) %>%
  group_by(quarter) %>% 
  summarize(births=sum(births, na.rm=T)
  )

ggplot(birth_data_q, aes(x=quarter, y=births)) + 
  geom_line() + 
  labs(title='US Births by Quarter 2000 - 2014', 
       x='Quarter', 
       y='Total Births')

# Try transforming the data to plot by year!

# 2. Year Over Year Comparisons ---- 

yoy_birth_data <- birth_data %>% 
  mutate(current_year=2014, 
         year_dif=current_year-year, 
         current_date=ifelse(year_dif==0, 
                             as.character(date), 
                             as.character(date + 364*year_dif - ifelse(weekdays(date - 363*year_dif) == weekdays(date),
                                                                  1,
                                                                  0)
                              )
         ), 
         current_date=as.Date(current_date), 
         current_week=floor_date(current_date, 'week'), 
         time_period=ifelse(year<2008, 
                            'Before 2008', 
                            'After 2008')
         
  ) 

filtered_yoy_births <- yoy_birth_data %>% 
  group_by(year, current_week) %>% 
  summarize(births=sum(births, na.rm=T)
            ) %>% 
  filter(year >= 2012 & 
           current_week > as.Date('2013-12-29') & 
           current_week < as.Date('2014-12-28')) 

ggplot(filtered_yoy_births, aes(x=current_week, y=births, color=as.character(year))) + 
  geom_line(size=1.5) + 
  labs(title='YoY Change in US Births by Week 2012-2014', 
       x='Current Week', 
       y='Total Births', 
       color='Year')

# Try adding some more years into this graph. Is this easier or harder to interpret?

# 3. Changing Buckets ---- 

before_after_2008<-yoy_birth_data %>% 
  group_by(time_period, current_week) %>% 
  summarize(births=sum(births, na.rm=T)) %>% 
  filter(current_week > as.Date('2013-12-29') & 
           current_week < as.Date('2014-12-14')
         )  

ggplot(before_after_2008, aes(x=current_week, y=births, color=time_period)) + 
  geom_line(size=1.5) + 
  labs(title='Births by Week Before and After 2008', 
       x='Current Week', 
       y='Total Births', 
       color='Time Period')


# Try adding an additional bucket to the time period bucket. 
# The buckets will be before 2005, 2005 - 2009, and after 2010 - 2014. 
# Rerun the above code with your new time_period variable. 
# What do you see?



