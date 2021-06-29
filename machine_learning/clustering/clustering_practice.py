import pandas as pd
from plotnine import *
from scipy import stats as st
from pydataset import data
import numpy as np
from sklearn.cluster import KMeans
from sklearn.neighbors import KNeighborsClassifier
import random
from sklearn.model_selection import train_test_split

custom_theme=theme(panel_background = element_rect(fill = 'white'), 
          panel_grid_major = element_line(colour = 'grey', size=0.5, linetype='dashed'), 
          panel_border = element_rect(fill=None, color='grey', size=0.5, linetype='solid')
    )

############################
#
# K-Means Clustering ----   
#
############################

grads_url='https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/recent-grads.csv'

grads_data = pd.read_csv(grads_url)

grads_data=grads_data[grads_data.ShareWomen.notnull()]

# What is the relation ship? Are there any Clusterd?

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median')) + 
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) + 
    custom_theme
    )

# Run K-Means Clusterd

kmeans = KMeans(n_clusters=4)

kmeans_model = kmeans.fit(grads_data[['Median','ShareWomen']])

grads_data['cluster'] = kmeans_model.predict(grads_data[['Median','ShareWomen']])

# Plot Clusters

(
    ggplot(grads_data) +
    geom_point(aes(x = 'ShareWomen', 
                   y='Median', 
                   color='cluster')) + 
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) + 
    custom_theme
    )
##############################################
#
# Rerun this model with 5 clusters. Do you think it is more represtative of the data to have 5 clusters? How could you interepret this output?
#
##############################################

# Testing with some randomized data 

test = pd.DataFrame(grads_data['ShareWomen'])

new=test.applymap(lambda x: x * (np.random.rand()*random.randint(-200, 500)))

grads_data['new_share_women']=new


(
    ggplot(grads_data) +
    geom_point(aes(x = 'new_share_women', 
                   y='Median')) + 
    labs(
        title ='Share of Women Majoring by Median Income of Major',
        x = 'Share of Women in Major',
        y = 'Median Income',
    ) + 
    custom_theme
    )

# Do you see any cluster? Run Kmeans on this data set. 


############################
#
# KNN Clustering ----   
#
############################

# Clean

grads_data['majority_female'] = np.where(grads_data['ShareWomen']>.5, 1, 0)

x = grads_data[{'ShareWomen'}]

y = grads_data['majority_female']

# Run KNN

x_training, x_test, y_training, y_test = train_test_split(x, y, test_size = 0.3)

knn = KNeighborsClassifier(n_neighbors=4)

knn.fit(x_training, y_training)

# Predictions

predictions = knn.predict(x_test)

# Compare 

test_predictions = pd.DataFrame({'predictions': predictions, 'actuals': y_test}, 
                                columns=['predictions', 'actuals'])

# Confusion Matrix 

pd.crosstab(test_predictions['actuals'], 
            test_predictions['predictions'], 
            rownames=['Actual'], 
            colnames=['Predicted'])  

precision= 29/(29+0) #TP/(TP+FP)


recall= 29/(29+0) #TP/(TP+FN)


f1=2*((precision*recall)/(precision+recall)) #2*((precision*recall)/precision+recall)

# What is the F1 score? Rerun this but instead of using the ShareWomen columns, use the new_share_women. 


