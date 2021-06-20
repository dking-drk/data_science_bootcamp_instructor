import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data
import numpy as np

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

est_multiple = smf.ols(formula='Median ~ share_women_percent+Unemployment_rate', data=grads_data).fit() 

est_multiple.summary()

# Run Mutlivariate regression on your own

est_births = smf.ols(formula='births ~ year+month', data=births_data).fit() 

est_births.summary()

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

############################
#
# Polynomial Regression ----   
#
############################

fit = np.polyfit(election_data['year'], election_data['demVote'], 2)
equation = np.poly1d(fit)
print ("The fit coefficients are a = {0:.4f}, b = {1:.4f} c = {2:.4f}".format(*fit))
print (equation)

election_data['polynomial']=(0.009066*election_data['year']**2)+(election_data['year']-35.92)+3.562e+04

(
    ggplot(election_data) +
    geom_point(aes(x = 'polynomial', 
                   y='demVote')) + 
    geom_smooth(aes(x = 'polynomial',
                    y = 'demVote'), 
                method='lm'
    ) +
    labs(
        title ='Share of Democratice Vote 1932-2012',
        x = 'Year',
        y = 'Share of Democratic Vote',
    ) + 
    custom_theme
    )

############################
#
# Difference in Difference ----   
#
############################

#### Create random data for dif-in-dif

# mass_1

fish_1 = np.random.randint(1, 100, size=121)

fish_df = pd.DataFrame(fish_1, columns=['total_fish'])

months=pd.date_range(start='2000-01-01',end='2010-01-01',freq='MS').to_frame()

mass_1=pd.concat([months.reset_index(drop=True), fish_df], axis=1)

mass_1['state'] = 'Massachusetts'

# mass_2

fish_2 = np.random.randint(50, 175, size=121)

fish_df_2 = pd.DataFrame(fish_2, columns=['total_fish'])

months_2=pd.date_range(start='2010-02-01',end='2020-02-01',freq='MS').to_frame()

mass_2=pd.concat([months_2.reset_index(drop=True), fish_df_2], axis=1)

mass_2['state'] = 'Massachusetts'

full_mass = mass_1.append(mass_2)

# maine_1

fish = np.random.randint(1, 100, size=242)

fish_maine = pd.DataFrame(fish, columns=['total_fish'])

months_maine=pd.date_range(start='2000-01-01',end='2020-02-01',freq='MS').to_frame()

maine=pd.concat([months_maine.reset_index(drop=True), fish_maine], axis=1)

maine['state'] = 'Maine'

full_fish_data=full_mass.append(maine)

full_fish_data=full_fish_data.rename(columns={0: "month"})

# Plot data 

(
    ggplot(full_fish_data) +
    geom_point(aes(x = 'month', 
                   y='total_fish', 
               color='state')) +
    labs(
        title ='Fish Stocks in Nassachusetts & Maine 2000-2020',
        x = 'Month',
        y = 'Fish Stock',
        color = 'State'
    ) +
    custom_theme
    )


    


