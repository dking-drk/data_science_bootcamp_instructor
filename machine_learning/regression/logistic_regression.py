import pandas as pd
from plotnine import *
import statsmodels.formula.api as smf
from scipy import stats as st
from pydataset import data
import numpy as np

custom_theme=theme(panel_background = element_rect(fill = 'white'), 
          panel_grid_major = element_line(colour = 'grey', size=0.5, linetype='dashed'), 
          panel_border = element_rect(fill=None, color='grey', size=0.5, linetype='solid')
    )

############################
#
# Running Predicitons on linear models ----   
#
############################

births_url = "https://raw.githubusercontent.com/fivethirtyeight/data/master/births/US_births_2000-2014_SSA.csv"

births_data = pd.read_csv(births_url)

est_births = smf.ols(formula='births ~ year+month', data=births_data).fit() 

est_births.summary()

# 70/30 split

# Creating a dataframe with 70% of values
births_data_70 = births_data.sample(frac = 0.70)
  
# Creating dataframe with with the other 30%
births_data_30 = births_data.drop(births_data_70.index)

births_data_train = smf.ols('births~year+month', data=births_data_70).fit()

births_data_30['prediction'] = births_data_train.predict(births_data_30) 

births_data_30['error_rate']=(births_data_30['prediction']-births_data_30['births'])/births_data_30['births']

births_data_30['date']=births_data_30['year'].astype(str) + '-' + births_data_30['month'].astype(str) + '-' + births_data_30['date_of_month'].astype(str)

births_data_30['date']=pd.to_datetime(births_data_30['date'])

births_data_30['week']=pd.to_datetime(births_data_30.date).dt.to_period('W').dt.to_timestamp()

agg_30=births_data_30.groupby('week', as_index=False).agg({"error_rate": "mean"})

(
    ggplot(agg_30) +
    geom_line(aes(x = 'week', 
                   y='error_rate')) +
    labs(
        title ='Average Model Error Rate by Week',
        x = 'Week',
        y = 'Avg. Error Rate'
    )  + 
    custom_theme
    )

# 1. What are some ways to improve this model? What other variables would we add?

#2. Try running the above code again but adding an additional variable to see if this improves the error rate.

############################
#
# Logistic regression ----   
#
############################

all_data=data()

food_stamp_part=data('foodstamp')

# Info on data https://rdrr.io/cran/robustbase/man/foodstamp.html

(
    ggplot(food_stamp_part) +
    geom_point(aes(x = 'income', 
                   y='participation')) + 
    geom_smooth(aes(x = 'income',
                    y = 'participation'), 
                method='lm'
    ) +
    labs(
        x = 'Income',
        y = 'Foodstamp Participation',
    ) + 
    custom_theme
    )

incomelogitfit = smf.logit(formula = 'participation ~ income', data = food_stamp_part).fit()

incomelogitfit.summary()

############################
#
# Log Ods to Probability ----   
#
############################

np.exp(-0.0021)

############################
#
# Logistic regression using titanic data ----   
#
############################

titanic = data('titanic')

titanic['did_survive']=np.where(titanic['survived']=='yes', 1, 0)

titanic['class_1'] = titanic['class']

titaniclogitfit = smf.logit(formula = 'did_survive ~ class_1', data = titanic).fit()

titaniclogitfit.summary()

np.exp(-1.5965)

np.exp(0.144)

# 3rd class survival rate

titanic.groupby(["class_1", "survived"]).size()

203/(122+203)

178/(528+178)

############################
#
# Running Predicitons on logistic models ----   
#
############################

# Creating a dataframe with 70% of values
titanic_70 = titanic.sample(frac = 0.70)
  
# Creating dataframe with with the other 30%
titanic_30 = titanic.drop(titanic_70.index)

traintitaniclogitfit = smf.logit(formula = 'did_survive ~ class_1', data = titanic_70).fit()

titanic_30['prediction'] = traintitaniclogitfit.predict(titanic_30 ) # This gives you probability of survival

titanic_30['pred_survive']=np.where(titanic_30['prediction']>.5, 1, 0)

pd.crosstab(titanic_30['did_survive'], 
            titanic_30['pred_survive'], 
            rownames=['Actual'], 
            colnames=['Predicted'])  

precision= 57/(27+57) #TP/(TP+FP)


recall= 57/(57+87) #TP/(TP+FN)


f1=2*((precision*recall)/(precision+recall)) #2*((precision*recall)/precision+recall)


# How could we improve this prediction? What are some variables we could add? 

# Starting from line 116, add sex as an additional independent variable to the model and rerun the code. What is F1 score of the prediciton?

















