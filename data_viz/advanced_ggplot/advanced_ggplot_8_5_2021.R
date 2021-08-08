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
             color='#00b3b3', 
             fill='#ffffff', 
             stroke=1.1)

# Play around with the fill and color using the html color picker here https://www.w3schools.com/colors/colors_picker.asp. 
# Then post it in the session-slack!

# 5. Cleaning Axis labeling ----

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
                                 color='black', 
                                 size=6) # Color of text labels
  ) + 
  scale_y_continuous(label=comma) + 
  labs(title='Median Income by Major Category', 
       x='Major Category', 
       y='Median Income After Graduation') + 
  custom_theme

# Change the angle of the bar plot to 90. Does this help the vizualization?


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
  geom_bar(stat='identity', position='dodge'
           ) +
  labs(title='Average Alcohol Consumption Per Serving by Region and Type', 
       x='Alcohol Type', 
       y='Average Alcohol per serving', 
       fill='Region') + 
  custom_theme

# Change the labels on this chart and post in the output in the session slack. 

# Color scales and continuous variables ----

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median, color=Unemployment_rate)) + 
  geom_point(size=2, alpha=.5) + 
  scale_color_gradient(low="white",
                        high="red") +
  #scale_color_viridis_c(option = "magma") + 
  labs(title='The Effect of the Share of Women in a Major on Median Income and Unemployment Rate ', 
       x='Share of Women in Major', 
       y='Median Income After Graduation', 
       color='Uneployment Rate') + 
  custom_theme

# Adjust the color scale of the map to use HTML colors and then post in the session slack. 
# Is the chart you created any better?

