library(tidyverse)
library(lubridate)
library(datasets)
options(scipen=999)

custom_theme <- theme(panel.background = element_rect(fill = "white"),
                      panel.grid.major = element_line(colour = "grey", size=0.5, linetype="dashed"),
                      panel.border = element_rect(fill=NA, color="grey", size=0.5, linetype="solid"),
                      plot.title=element_text(family="inherit", size = "13")
)

################################
#
# Adjusting Plot Outputs ----
#
################################

# Adjusting Line Chart Outputs ----

births_raw_url="https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

birth_data<-read.csv(url(births_raw_url)) 

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

# Adjusting Scatter Plot Outputs ----

ggplot(recent_grad_data, aes(x=ShareWomen, y=Median)) + 
  geom_point(size=2, #This is the argument to change the size of the point
              color='black', #This is the argument to change the color of the point, colors are (red, blue, green, yellow, black, white, etc)
              fill='yellow', # This argument changes the inside of the point, when the shape has an inside and outside 
              alpha=.5, # This argument changes the transparency
              shape=21, # This changes the shape of the point
              stroke=2 # This argument changes the width of the line around the point
  )

# Change the shape and alpha to whatever numbers you want. Do you think this makes for a better plot?

# Adjusting Bar Plots ----

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
  

