library(tidyverse)
library(lubridate)
library(datasets)
options(scipen=999)

custom_theme <- theme(panel.background = element_rect(fill = "white"),
                      panel.grid.major = element_line(colour = "grey", size=0.5, linetype="dashed"),
                      panel.border = element_rect(fill=NA, color="grey", size=0.5, linetype="solid"),
                      plot.title=element_text(family="inherit", size = "13")
)

# Introduction to data viz exercise 

# First mass data set ----

## Simulate predictor variable
x <- abs(rnorm(121))          

## Simulate the error term
e <- rnorm(121, 0, 2)    

## Compute the outcome via the model
y <- 10 + 4 * x + e 

mass_1<-bind_cols(x,y) %>% 
  rename(date_number=`...1`, 
         fish_stock=`...2`) %>% 
  arrange(date_number) %>%
  mutate(month=seq(from=as.Date('2000-01-01'), 
                   to=as.Date('2010-01-01'), 
                   by='month'), 
         state='Massachusetts')


ggplot(mass_1, aes(x=month, y=fish_stock)) +
  geom_point() + 
  geom_smooth(method='lm') 


# Second mass data set ----

## Simulate predictor variable
x <- abs(rnorm(121))          

## Simulate the error term
e <- rnorm(121, 0, 2)    

## Compute the outcome via the model
y <- 20 + 30 * x + e 

mass_total<-mass_1 %>% 
  bind_rows(bind_cols(x,y) %>% 
              rename(date_number=`...1`, 
                     fish_stock=`...2`) %>% 
              arrange(date_number) %>%
              mutate(month=seq(from=as.Date('2010-02-01'), 
                               to=as.Date('2020-02-01'), 
                               by='month'), 
                     state='Massachusetts'))

# All Maine data ----

## Simulate predictor variable
x <- abs(rnorm(242))          

## Simulate the error term
e <- rnorm(242, 0, 2)    

## Compute the outcome via the model
y <- 10 + 4 * x + e 

all_fish_data<-mass_total %>% 
  bind_rows(bind_cols(x,y) %>% 
              rename(date_number=`...1`, 
                     fish_stock=`...2`) %>% 
              arrange(date_number) %>%
              mutate(month=seq(from=as.Date('2000-01-01'), 
                               to=as.Date('2020-02-01'), 
                               by='month'), 
                     state='Maine')) + 
  labs(title='Fish Stock in Maine and Massachusetts between 2000 and 2020', 
       x='Month', 
       y='Total Fish (in Millions)')

ggplot(all_fish_data, aes(x=month, y=fish_stock, color=state)) +
  geom_point() + 
  geom_smooth() + 
  custom_theme

# Anscombs Quartet ----

summary(glm(y1~x1, data=anscombe))

summary(glm(y2~x2, data=anscombe))

# Run the above code for y3, x3, y4, x4. Do you notice a similar pattern? (Take 5 Minutes)

ans_x<-anscombe %>% 
  select(1:4) %>%
  rename(`1`=x1, 
         `2`=x2, 
         `3`=x3, 
         `4`=x4) %>% 
  gather('data_example', 'total_x', 1:4) %>% 
  select(total_x)

ans_y<-anscombe%>% 
  select(5:8) %>%
  rename(`1`=y1, 
         `2`=y2, 
         `3`=y3, 
         `4`=y4) %>% 
  gather('data_example', 'total_y', 1:4) 

total_anscombe<-ans_y %>% 
  bind_cols(ans_x) 

ggplot(total_anscombe, aes(x=total_x, y=total_y)) + 
  geom_point() + 
  geom_smooth(method='lm', alpha=0) + 
  labs(title='Example of Anscombe\'s Quartet', 
       x='X Variable', 
       y='Y Variable') + 
  facet_wrap(~data_example) + 
  custom_theme

################################
#
# Grammar Graphics ----
#
################################

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

# 1. The Plot ----

my_base_plot<-ggplot(birth_data, aes(x=date, y=births))

my_base_plot

# What does aes() stand for?

?aes()

# Copy and paste this plot into the session slack!

# 2. The plot ----

line_plot <- my_base_plot + 
  geom_line() 

line_plot

# Copy and paste this plot into the session slack!

# 3. Adding Plots on Top of Plots ----

week_birth_data <- birth_data %>% 
  group_by(week) %>% 
  summarize(ave_births=mean(births, na.rm=T), 
            total_births=sum(births, na.rm=T)) %>% 
  filter(week>as.Date('1999-12-26') & 
           week < as.Date('2014-12-28'))

line_smoothed<-line_plot + 
  geom_line(data=week_birth_data, 
            aes(x=week, y=ave_births), 
            color='orange')

line_smoothed

# What does the "color" argument do?

# Create a graph overlaying the total_births instead of the ave_births. Why would we not want this?

# 4. Adding labels ----

line_with_labels <- line_smoothed + 
  labs(title='US Births by Day and Week 2000-2014', 
       subtitle='Week Line in Orange Shows Average Births by Day', 
       x='Date', 
       y='Births')

line_with_labels

# Do you think there is anything we can do to make these labels clearer? 
# Change the subtitle and paste the plot into the session slack!

# 5. Adding horzontal lines ----

ave_line_with_labels <- line_with_labels + 
  geom_hline(yintercept=mean(birth_data$births, 
                             na.rm=T), 
             color='white'
             )

ave_line_with_labels

# Add an additional horizontal line for the minimum births in a day!

# 6. Adding vertical lines ----

vert_ave_line_with_labels <- ave_line_with_labels + 
  geom_vline(xintercept=c(as.Date('2008-01-01')), 
             color='red'
  )

vert_ave_line_with_labels

# Add one more date as a vertical line in the chart!

# 7. Adding vertical lines ----

final_plot <- vert_ave_line_with_labels + 
  geom_smooth(aes(x=date, y=births))

final_plot

# Copy and paste this graph into the session slack!



