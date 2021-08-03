library(tidyverse)
library(lubridate)
library(datasets)
library(scales)
options(scipen=999)

custom_theme <- theme(panel.background = element_rect(fill = "white"),
                      panel.grid.major = element_line(colour = "grey", size=0.5, linetype="dashed"),
                      panel.border = element_rect(fill=NA, color="grey", size=0.5, linetype="solid"),
                      plot.title=element_text(family="inherit", size = "13")
)

# Some initial data ----

git_grad='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

recent_grad_data<-read.csv(url(git_grad))

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

# Warm up --------

# Using the birth_data data frame, create a new data frame aggregating births by month and then create a line plot. 

################################
#
# Preparing Data for Visualization ----
#
################################

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

################################
#
# Adjusting Plot Outputs ----
#
################################

# 1. Adjusting Line Chart Outputs ----

birth_data_week <- birth_data %>%
  mutate(date=as.Date(paste0(year,
                             '-',
                             month,
                             '-',
                             date_of_month)
  ), 
  week=floor_date(date, 'week')
  ) %>% 
  group_by(week) %>% 
  summarize(births=sum(births, na.rm=T)
            ) %>% 
  filter(week>as.Date('1999-12-26') & 
           week < as.Date('2014-12-28'))

ggplot(birth_data_week, aes(x=week, y=births)) + 
  geom_line(size=.5, #This is the argument to change the width of the line
            color='blue', #This is the argument to change the color of the line, colors are (red, blue, green, yellow, black, white, etc)
            linetype='solid' # Line types are dashed, solid, dotted, dotdash, longdash, twodash
            )

# 1. Add labels to the plot above. 
# 2. Change the linetype to dashed and the size to 3. Does this make the plot any better? 

# 2. Adjusting Scatter Plot Outputs ----

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median)) + 
  geom_point(size=2, #This is the argument to change the size of the point
              color='black', #This is the argument to change the color of the point, colors are (red, blue, green, yellow, black, white, etc)
              fill='yellow', # This argument changes the inside of the point, when the shape has an inside and outside 
              alpha=.5, # This argument changes the transparency
              shape=21, # This changes the shape of the point
              stroke=2 # This argument changes the width of the line around the point
  )

# Change the shape and alpha to whatever numbers you want. Do you think this makes for a better plot?

# 3. Adjusting Bar Plots ----

birth_data_year<-birth_data %>% 
  group_by(year) %>% 
  summarize(births=sum(births, na.rm=T)
            )

ggplot(birth_data_year, aes(x=year, y=births)) + 
  geom_bar(stat='identity', 
           color='black', 
           fill='orange', 
           width=.75,
           alpha=.5)

# Change the colors and fill. Do you think this makes for a better plot?

# 4 Labeling Points ----

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median)) + 
  geom_point(size=3) + 
  geom_text(aes(label=Major),# Specify the variable that you want to use!
            size=2, # Size of font
            check_overlap=T, # Does not label point if it overlaps a previous label
            color='black', # Color of your font 
            vjust = 1.5) # Directional adjustment around the point 

# Try labeling with the Major_category column. Do you think this helps tell your story better?

# 5. HTML colors

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median)) + 
  geom_point(size=3, 
             shape=21, 
             color='#4c6a2f', 
             fill='#ffffff', 
             stroke=1.1)

# Play around with the fill and color using the html color picker here https://www.w3schools.com/colors/colors_picker.asp. 
# Then post it in the session-slack!

# 5. HTML colors

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median)) + 
  geom_point(size=3, 
             shape=21, 
             color='#4c6a2f', 
             fill='#ffffff', 
             stroke=1.1)

# Play around with the fill and color using the html color picker here https://www.w3schools.com/colors/colors_picker.asp. 
# Then post it in the session-slack!

# 5. Cleaning Axis labeling

median_major_category <- recent_grad_data %>% 
  group_by(Major_category) %>% 
  summarize(median_income=median(Median, na.rm=T))

ggplot(median_major_category, aes(x=reorder(Major_category, 
                                            -median_income), 
                                  y=median_income)
       ) + 
  geom_bar(stat='identity') + 
  theme(axis.text.x=element_text(angle=45, # The angle of the labels in relation to the x axis itself
                                 hjust=1, # Horizontal adjustment up or down of labels
                                 color='black') # Color of text labels
        ) + 
  scale_y_continuous(label=comma) + 
  labs(title='Median Income by Major Category', 
       x='Major Category', 
       y='Median Income After Graduation') + 
  custom_theme
  

# Adjust the axis.text.x elements. Change around the angle, hjust, and color. Does the new output look better?
# Then post it in the session-slack!

################################
#
# Multidimensional Plots ----
#
################################

# Facet Wrap ----

git_drinks='https://raw.githubusercontent.com/fivethirtyeight/data/master/alcohol-consumption/drinks.csv'

git_region='https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv'

drinks_data<-read.csv(url(git_drinks)) %>% 
  select(-total_litres_of_pure_alcohol) %>%
  gather('drink_type', 
         'average_serving_size', 
         2:4) %>% 
  left_join(read.csv(url(git_region)) %>% 
              select(name, region), 
            by=c('country'='name')) %>% 
  filter(!is.na(region))

drinks_ag_region<-drinks_data %>% 
  group_by(region, drink_type) %>% 
  summarize(average_serving_size=mean(average_serving_size, na.rm=T))

ggplot(drinks_ag_region, aes(x=reorder(drink_type, 
                                       -average_serving_size), 
                             y=average_serving_size)) + 
  geom_bar(stat='identity') + 
  theme(axis.text.x=element_text(angle=90, # The angle of the labels in relation to the x axis itself
                                 hjust=1, # Horizontal adjustment up or down of labels
                                 color='black') # Color of text labels
  ) + 
  labs(title='Average Alcohol Consumption Per Serving by region and Type', 
       x='Alcohol Type', 
       y='Average Alcohol per serving') + 
  facet_wrap(~region) +
  custom_theme

# Using the drinks_data data frame, use country as the x variable and drink_type as the facet_wrap. 
# Is this a better chart? Why/why not?

# Color and Fill ----

ggplot(drinks_ag_region, 
       aes(x=reorder(drink_type, 
                     -average_serving_size), 
           y=average_serving_size,
           fill=region
           )
       ) + 
  geom_bar(stat='identity', position='dodge') +
  labs(title='Average Alcohol Consumption Per Serving by Region and Type', 
       x='Alcohol Type', 
       y='Average Alcohol per serving', 
       fill='Region') + 
  custom_theme

# Change the labels on this chart and post in the output in the session slack. 

# Color scales and continuous variables ----

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median, color=Unemployment_rate)) + 
  geom_point(size=2, alpha=.5) + 
  # scale_color_gradient(low="white",
  #                       high="red") + 
  scale_color_viridis_c(option = "magma") + 
  labs(title='The Effect of the Share of Women in a Major on Median Income and Unemployment Rate ', 
       x='Share of Women in Major', 
       y='Median Income After Graduation', 
       color='Uneployment Rate') + 
  custom_theme

# Adjust the color scale of the map to use HTML colors and then post in the session slack. 
# Is the chart you created any better?
  






  

