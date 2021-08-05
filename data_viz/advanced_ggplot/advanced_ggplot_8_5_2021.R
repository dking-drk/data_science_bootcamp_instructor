library(tidyverse)
library(lubridate)
library(datasets)
library(scales)
library(leaflet)
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

# Warm up ----

# Using the births data data set, create a line plot by week and births and then use year as the color line. Post you plot in the sessions slack. 

################################
#
# Adjusting Plot Outputs ----
#
################################

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

# Change the angle of the batr plot to 90. Does this help the vizualization?


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

################################
#
# Advanced Plots ----
#
################################

# Heat Maps ----

birth_day_month<-birth_data %>% 
  mutate(weekday=weekdays(date),
         month_name=month(date, label=T), 
         weekday=factor(weekday, 
                        levels = c('Monday', 
                                   'Tuesday',
                                   'Wednesday', 
                                   'Thursday', 
                                   'Friday', 
                                   'Saturday', 
                                   'Sunday')
         )
  ) %>%
  group_by(month_name, weekday) %>% 
  summarize(ave_births=mean(births, na.rm=T)) %>% 
  ungroup() 

ggplot(birth_day_month, 
       aes(x=weekday, 
           y=month_name, 
           fill=ave_births)) + 
  geom_tile() +
  scale_fill_gradient(low="white", 
                      high="red") + 
  labs(title='Average Births by Month and Day of week', 
       x='Weekday', 
       y='Month', 
       fill='Ave. Births') + 
  custom_theme

# Remove the section of code that relevels the factors and then run this section again. 
# Does this make for a better vizualization?

# Violin Plots ----

quarter_births <- birth_data %>% 
  mutate(seasons=ifelse(month %in% c(3,4,5), 
                        'Spring', 
                        ifelse(month %in% c(6,7,8), 
                               'Summer', 
                               ifelse(month %in% c(9,10,11), 
                                      'Fall', 
                                      'Winter')
                        )
  )
  )

ggplot(quarter_births, aes(x=seasons, births)) + 
  geom_violin(draw_quantiles=c(0.25, 0.5, 0.75), 
              fill='#ff6666', 
              alpha=.5) + 
  labs(title='Births Density by Season', 
       x='Season', 
       y='Total Births') + 
  custom_theme

# Draw only the .5 quantile. Do you think this is a better visualization?

# Density Plots

many_births <- birth_data %>% 
  filter(month==8) %>% 
  mutate(weekday=weekdays(date),
         weekday=factor(weekday, 
                        levels = c('Monday', 
                                   'Tuesday',
                                   'Wednesday', 
                                   'Thursday', 
                                   'Friday', 
                                   'Saturday', 
                                   'Sunday')
         )
  )

ggplot(many_births, aes(x=births, 
                        fill = weekday, 
                        color = weekday
)
)+
  geom_density(alpha = 0.1) + 
  labs(title='Births by Weekday in August (Density)', 
       x='Total Births', 
       y='Density') + 
  custom_theme 

# Remove Saturday and Sunday from the chart and then post the new chart in the session slack.

# Geospatial Plots 1 ----

#https://rstudio.github.io/leaflet/

leaflet() %>% 
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron)

# Go here https://rstudio.github.io/leaflet/basemaps.html and find another base map to use. 

# Geospatial Plots 2 ----

parking='https://bostonopendata-boston.opendata.arcgis.com/datasets/962da9bb739f440ba33e746661921244_9.csv?outSR=%7B%22latestWkid%22%3A2249%2C%22wkid%22%3A102686%7D'

meters_data<-read.csv(url(parking))

leaflet(meters_data) %>% 
  setView(lng = -71.0589, lat = 42.3601, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addMarkers(lng = ~LONGITUDE, 
             lat = ~LATITUDE, 
             clusterOptions = markerClusterOptions()
  )

# Zoom in on the map to the part of the city that says "Boston" then take a screen shot and post in the session slack.

