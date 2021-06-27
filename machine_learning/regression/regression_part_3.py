import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import PolynomialFeatures

# Define plot themes 

custom_theme=theme(panel_background = element_rect(fill = 'white'), 
          panel_grid_major = element_line(colour = 'grey', size=0.5, linetype='dashed'), 
          panel_border = element_rect(fill=None, color='grey', size=0.5, linetype='solid')
    )

############################
#
# Warm Up with bidary Operators ----   
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
# Fitting Curves ----   
#
############################

(
    ggplot(election_data) +
    geom_point(aes(x = 'year', 
                   y='demVote')) + 
    geom_smooth(aes(x = 'year',
                y='demVote'), 
                method='lm') +
    labs(
        title ='Share of Democratice Vote 1932-2012',
        x = 'Year',
        y = 'Share of Democratic Vote',
    ) + 
    custom_theme
    )

dem_vote_yr = smf.ols('demVote~year', data=election_data).fit()

dem_vote_yr.summary()

(
    ggplot(election_data) +
    geom_point(aes(x = 'year', 
                   y='demVote')) + 
    geom_smooth(aes(x = 'year',
                y='demVote'), 
                method='loess') +
    labs(
        title ='Share of Democratice Vote 1932-2012',
        x = 'Year',
        y = 'Share of Democratic Vote',
    ) + 
    custom_theme
    )

# Create arrays for my x and y columns

#Create single dimension
x= election_data['year'][:,np.newaxis]
y= election_data['demVote'][:,np.newaxis]

inds = x.ravel().argsort()  # Sort x values and get index 
x = x.ravel()[inds].reshape(-1,1)
y = y[inds] #Sort y according to x sorted index

#Plot
plt.scatter(x,y)

polynomial_features=PolynomialFeatures(degree=3)
xp = polynomial_features.fit_transform(x)

##################### Using statsmodel instead of formula

import statsmodels.api as sm

model = sm.OLS(y, xp).fit()
model.summary()

ypred = model.predict(xp) 

plt.scatter(x,y)
plt.plot(x,ypred)

# Over fitting -------------------------------------

polynomial_features=PolynomialFeatures(degree=50)
xp = polynomial_features.fit_transform(x)

##################### Using statsmodel instead of formula

model = sm.OLS(y, xp).fit()
model.summary()

ypred = model.predict(xp) 

plt.scatter(x,y)
plt.plot(x,ypred)


############################
#
# Difference in Difference ----   
#
############################

#### Pull in data for dif-in-dif model

fish_stock_data=pd.read_csv('./machine_learning/regression/dif_and_dif_data.csv') 

fish_stock_data['month']= pd.to_datetime(fish_stock_data['month'])

fish_stock_data['is_mass']=np.where(fish_stock_data['state']=='Massachusetts', 1, 0)

fish_stock_data['is_post']=np.where(fish_stock_data['month']>'2010-01-01', 1, 0)

# Plot data 

(
    ggplot(fish_stock_data) +
    geom_point(aes(x = 'month', 
                   y='fish_stock', 
               color='state')) +
    labs(
        title ='Fish Stocks in Massachusetts & Maine 2000-2020',
        x = 'Month',
        y = 'Fish Stock',
        color = 'State'
    )  + 
    custom_theme
    )

dif_in_dif_est=smf.ols('fish_stock ~ date_number + is_mass*is_post', data=fish_stock_data).fit()

dif_in_dif_est.summary()


