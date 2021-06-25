library(tidyverse)
library(lubridate)

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

ggplot(mass_total, aes(x=month, y=fish_stock)) +
  geom_point() + 
  geom_smooth(method='lm')

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
         state='Maine'))

ggplot(all_data, aes(x=month, y=fish_stock, color=state)) +
  geom_point() + 
  geom_smooth(method='lm')

write.csv(all_fish_data, 
          './machine_learning/regression/dif_and_dif_data.csv', 
          row.names=F)




  
  



