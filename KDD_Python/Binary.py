import os
import numpy as np
import pandas as pd
import matplotlib as mlp_plt
import matplotlib.pyplot as plt
from matplotlib import style

from sklearn.preprocessing import StandardScaler, RobustScaler, LabelEncoder
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score, classification_report, roc_auc_score, confusion_matrix, r2_score, mean_squared_error
from sklearn.model_selection import cross_val_predict, cross_val_score, StratifiedKFold

np.set_printoptions(threshold=np.nan)
plt.style.use('fivethirtyeight')

import seaborn as sns

######################################
## Reading the data + Preprocessing ##
######################################

data = pd.read_csv("../DATA.csv")
print('KDD Dataset imported...\n')

##print(data.describe())
print('Dataframe header\n')
print(data.head())
print("Dataframe shape: ", data.shape)

## Network features
Inputs = ['count','srv_serror_rate','protocol','logged_in','service',
          'dst_host_same_src_port_rate','dst_host_diff_srv_rate',
          'attack_type','attack_name','class']
data = data[Inputs]
##print(data)

## Encoding categorical features
le = LabelEncoder()
data = data.apply(le.fit_transform)
print('Encoded categorical features.')

# Target (Binary)
##y = np.array(data['class'])
y = data['class'].as_matrix().astype(np.int)

## Drop redundant columns from dataframe
data.drop(['attack_type','attack_name','class'], axis=1, inplace=True)

## Print current dataframe 
print('Data before split...\n')
print(data.head())

## Data 
X = data.as_matrix().astype(np.float)
print('The shape of X is: ', X.shape)

# Scale data
standard_scaler = StandardScaler()
X = standard_scaler.fit_transform(X) ## BEWARE OF SCALING CATEGORICAL VARIABLES

##robust_scaler = RobustScaler()
##X_train_r = robust_scaler.fit_transform(X_train)
##X_test_r = robust_scaler.transform(X_test)
print('Data has been scaled...\n')


######################################
## Model ##
######################################

mlp = MLPClassifier(hidden_layer_sizes=(8,7), random_state=1)
mlp.activation = 'logistic' ##'tanh'
mlp.solver = 'sgd'
mlp.max_iter = 500
mlp.learning_rate_init = 0.001
mlp.learning_rate = 'adaptive' ##'constant','invscaling','adaptive'

print('MLP Neural Network Model Initialised...')
print (mlp)

stratified_k_fold = StratifiedKFold(n_splits=3, shuffle=True)
scores = cross_val_score(mlp, X, y, cv=stratified_k_fold, verbose=1)

y_pred = cross_val_predict(mlp, X, y, cv=stratified_k_fold, verbose=1 )

print('The shape of Y is: ', y.shape)
print('The shape of predicted Y is: ', y_pred.shape)


## Classification report
print(classification_report(y, y_pred, digits=5))

## R2
print('MLP Classifier R2: ', r2_score(y, y_pred))

print('MLP Classifier MSE: ', mean_squared_error(y, y_pred))

## Confusion Matrix
mlp_conf_matrix = confusion_matrix(y, y_pred)

conf_matrix = {
                1: {
                    'matrix': mlp_conf_matrix,
                    'title': 'Multilayer Perceptron Classifier (Binary)',
                   },      
}

fix, ax = plt.subplots(figsize=(16, 12))
plt.suptitle('Confusion Matrix of Various Classifiers')
for ii, values in conf_matrix.items():
    matrix = values['matrix']
    title = values['title']
    plt.subplot(3, 3, ii) # starts from 1
    plt.title(title);
    sns.heatmap(matrix, annot=True,  fmt='');

sns.plt.show()
