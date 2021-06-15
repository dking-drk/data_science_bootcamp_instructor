# Regression Example
from sklearn.datasets import make_regression
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
import numpy as np

x,y = make_regression(n_samples=1000, n_features=1, noise=3)

plt.scatter(x,y)
plt.show()