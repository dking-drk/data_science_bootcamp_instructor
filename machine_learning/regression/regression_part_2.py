import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data
import numpy as np
from sklearn.preprocessing import PolynomialFeatures

# Define plot themes 

custom_theme=theme(panel_background = element_rect(fill = 'white'), 
          panel_grid_major = element_line(colour = 'grey', size=0.5, linetype='dashed'), 
          panel_border = element_rect(fill=None, color='grey', size=0.5, linetype='solid')
    )

############################
#
# Regression (warm up) ----   
#
############################

bd_link='https://raw.githubusercontent.com/fivethirtyeight/data/master/bad-drivers/bad-drivers.csv'

bad_drivers = pd.read_csv(bd_link)

bad_drivers=bad_drivers.rename(columns={"Car Insurance Premiums ($)": "car_insurance_premiums", 
                               "Percentage Of Drivers Involved In Fatal Collisions Who Were Speeding": "percent_speeding_fatal"})

insurance_est = smf.ols(formula='car_insurance_premiums ~ percent_speeding_fatal', 
                data=bad_drivers).fit() 

insurance_est.summary()

############################
#
# Regression Project ----   
#
############################

women_emplyment=data('Mroz')

############################
#
# Multivariate Regression ----   
#
############################

grads_url='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

grads_data = pd.read_csv(grads_url)

grads_data=grads_data[grads_data.ShareWomen.notnull()]

grads_data['share_women_percent']=grads_data['ShareWomen']*100

grads_data['unemployment_percent']=grads_data['Unemployment_rate']*100

# Graph for multivariate regression

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median', 
               color='Unemployment_rate')) + 
    geom_smooth(aes(x = 
                    'ShareWomen',
                    y = 'Median'), 
                method='lm'
    ) +
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) 
    )

# Run the OLS estimation for multivariate regression

est_multiple = smf.ols(formula='Median ~ share_women_percent+unemployment_percent', data=grads_data).fit() 

est_multiple.summary()

# Run Mutlivariate regression on your own

births_url = "https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data = pd.read_csv(births_url)

est_births = smf.ols(formula='births ~ year+month', data=births_data).fit() 

est_births.summary()


(
    ggplot(births_data) +
    geom_point(aes(x = 'year', 
                   y='births')) + 
    geom_smooth(aes(x = 
                    'year',
                    y = 'births'), 
                method='lm'
    ) 
    )

############################
#
# Multivariate Regression with Factors ----   
#
############################

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median')) + 
    geom_smooth(aes(x = 
                    'ShareWomen',
                    y = 'Median'), 
                method='lm'
    ) +
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) + 
    facet_wrap('~Major_category')
    )

est_multiple = smf.ols(formula='Median ~ share_women_percent+Major_category', data=grads_data).fit() 

est_multiple.summary()


############################
#
# Binary Operators ----   
#
############################

election_data=data('presidentialElections')

election_data['is_south']=np.where(election_data['south']==True, 1, 0)

(
    ggplot(election_data) +
    geom_point(aes(x = 'year', 
                   y='demVote')) + 
    geom_smooth(aes(x = 'year',
                    y = 'demVote'), 
                method='lm'
    ) +
    labs(
        title ='Share of Democratice Vote 1932-2012',
        x = 'Year',
        y = 'Share of Democratic Vote',
    ) + 
    facet_wrap('~is_south') + 
    custom_theme
    )

est_binary = smf.ols(formula='demVote ~ is_south+year', data=election_data).fit() 

est_binary.summary()










