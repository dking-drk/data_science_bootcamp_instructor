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
# Warm Up with bindary Operators ----   
#
############################

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

dem_vote_yr = smf.ols('demVote~year', data=final_election_df).fit()

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

polynomial_features=PolynomialFeatures(degree=2)
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

############################
#
# Running Predicitons ----   
#
############################


    


