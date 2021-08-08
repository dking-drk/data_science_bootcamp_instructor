library(tidyverse)
library(lubridate)
library(datasets)
library(scales)
library(leaflet)
library(plotly)
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

# Install the plotly and leaflet packages. Remember the format is install.packages('plotly').

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

tile_births<-ggplot(birth_day_month, 
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

tile_births

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

violin_births <- ggplot(quarter_births, aes(x=seasons, births)) + 
  geom_violin(draw_quantiles=c(0.25, 0.5, 0.75), 
              fill='#ff6666', 
              alpha=.5) + 
  labs(title='Births Density by Season', 
       x='Season', 
       y='Total Births') + 
  custom_theme

violin_births

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

density_births <- ggplot(many_births, aes(x=births, 
                        fill = weekday, 
                        color = weekday
)
)+
  geom_density(alpha = 0.1) + 
  labs(title='Births by Weekday in August (Density)', 
       x='Total Births', 
       y='Density') + 
  custom_theme 

density_births

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

################################
#
# Plotly ----
#
################################

week_births<-birth_data %>% 
  group_by(week) %>% 
  summarize(births=sum(births, na.rm=T)) %>% 
  filter(week>=as.Date('2000-01-01') & 
           week<as.Date('2014-12-28'))

# Getting started with Plotly ----

plot_ly(week_births, x = ~week, 
        text = ~paste("Week Date: ", week, 
                      '\nBirths:', births)) %>% 
  add_trace(y = ~births, 
            name = 'Total Births', 
            mode = 'lines') %>% 
  layout(
    title = "Total Births by Week, 2000 - 2014",
    xaxis = list(
      title = "Week"
      ), 
    yaxis = list(
      title = "Total Births"
      ) 
  )

# Aggregate the births data by quarter and then replot in plotly (x=quarter, y = births). 
# Make sure to adjust the labels and titles in Plotly. 
# Take a screen shot and post in the Session Slack. 

ggplotly(tile_births)

# Using any of the other plots we created above, use ggplotly to make that plot interactive. 
# Take a screen shot of the plot and post in the session-slack. 
