import os
import numpy as np
import pandas as pd
import matplotlib as mlp_plt
import matplotlib.pyplot as plt
from matplotlib import style

from sklearn.preprocessing import StandardScaler, RobustScaler, MinMaxScaler, LabelEncoder, label_binarize
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score, classification_report, roc_auc_score, confusion_matrix, r2_score, roc_curve, auc, mean_squared_error
from sklearn.model_selection import cross_val_predict, cross_val_score, train_test_split, StratifiedKFold, learning_curve
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2

from collections import defaultdict
d = defaultdict(LabelEncoder)

np.set_printoptions(threshold=np.nan)
plt.style.use('fivethirtyeight')

import seaborn as sns

######################################
## Reading the data + Preprocessing ##
######################################

# Import merged dataset
##data = pd.read_csv("../Data/Data_Sets/Dataset_w_extras.csv")
# Import original dataset
data = pd.read_csv("../Data/Data_Sets/Dataset_b4_merge.csv")

# Import no duplicate dataset
##data = pd.read_csv("../Data/Data_Sets/Data_No_Duplicates.csv")

print('KDD Dataset imported...\n')

##print(data.describe())
print('Dataframe header\n')
print(data.head())
print("Dataframe shape: ", data.shape)


## Encoding categorical features
le = LabelEncoder()
data = data.apply(le.fit_transform)
print('Encoded categorical features.')
##data.to_csv('test.csv', sep=',')

# Target (Category)(Multi-Class)
##y = np.array(data['class'])
y = data['attack_type'].as_matrix().astype(np.int)
print(y.shape)

## Drop redundant columns from dataframe
data.drop(['attack_type','attack_name','class'], axis=1, inplace=True)

## Print current dataframe 
print('Data before split...\n')
print(data.head())

## Data 
X = data.as_matrix().astype(np.float)
print('The shape of X is: ', X.shape)

# Feature extraction using Chi2
selector  = SelectKBest(score_func=chi2, k=6)
fit = selector.fit(X, y);

np.set_printoptions(precision=3)
print(fit.scores_)
X = fit.transform(X)
print('The shape of X after selection is: ', X.shape)
print ('Network features: \n', selector.get_support())

# Scale data
scaler = MinMaxScaler(feature_range=(0, 1))## BEWARE OF SCALING CATEGORICAL VARIABLES
X = scaler.fit_transform(X)
print(X[0:5,:])
print('Data has been scaled...\n')

######################################
## Model ##
######################################

mlp = MLPClassifier(hidden_layer_sizes=(8,7), random_state=1)
mlp.activation = 'logistic' ##'tanh'
mlp.solver = 'sgd'
mlp.max_iter = 1000 ## 300 
mlp.learning_rate_init = 0.1 #0.001
mlp.learning_rate = 'adaptive' ##'constant','invscaling','adaptive'
mlp.momentum = 0.9;

print('MLP Neural Network Model Initialised...')
print (mlp)
print('\n')

## Perform stratified cross validation
print('Training network model...')
stratified_k_fold = StratifiedKFold(n_splits=3, shuffle=True)
scores = cross_val_score(mlp, X, y, cv=stratified_k_fold, verbose=1)
y_pred = cross_val_predict(mlp, X, y, cv=stratified_k_fold, verbose=1 )

##le.inverse_transform(y_pred)
##le.inverse_transform(y)

##print('Predicted data... \n')
##print(y_pred)
print('The shape of Y is: ', y.shape)
print('The shape of predicted Y is: ', y_pred.shape)


## Classification report
print(classification_report(y, y_pred, digits=5))

## R2
print('MLP Classifier R2: ', r2_score(y, y_pred))

print('MLP Classifier MSE: ', mean_squared_error(y, y_pred))
##print('Accuracy: {:.3f}'.format(scores.mean()*100.0))

mlp_conf_matrix = confusion_matrix(y, y_pred)
print('Confusion Matrix Output...\n')
print(mlp_conf_matrix)

conf_matrix = {
                1: {
                    'matrix': mlp_conf_matrix,
                    'title': 'Multilayer Perceptron Classifier (Multi - 5 Classes)',
                   },      
}

fix, ax = plt.subplots(figsize=(16, 12))
plt.suptitle('Confusion Matrix of neural network classification')
for ii, values in conf_matrix.items():
    matrix = values['matrix']
    title = values['title']
    plt.title(title);
    sns.heatmap(matrix, annot=True,  fmt='');

sns.plt.show()

#### ROC CURVE
##
##fpr = dict()
##tpr = dict()
##roc_auc = dict()
##for i in range(5):
##    fpr[i], tpr[i], _ = roc_curve(y[:, i], y_pred[:, i])
##    roc_auc[i] = auc(fpr[i], tpr[i])
##
### Compute macro-average ROC curve and ROC area
##
### First aggregate all false positive rates
##all_fpr = np.unique(np.concatenate([fpr[i] for i in range(5)]))
##
### Then interpolate all ROC curves at this points
##mean_tpr = np.zeros_like(all_fpr)
##for i in range(5):
##    mean_tpr += interp(all_fpr, fpr[i], tpr[i])
##
### Finally average it and compute AUC
##mean_tpr /= 5
##
##fpr["macro"] = all_fpr
##tpr["macro"] = mean_tpr
##roc_auc["macro"] = auc(fpr["macro"], tpr["macro"])
##
### Plot all ROC curves
##plt.figure()
##plt.plot(fpr["micro"], tpr["micro"],
##         label='micro-average ROC curve (area = {0:0.2f})'
##               ''.format(roc_auc["micro"]),
##         color='deeppink', linestyle=':', linewidth=4)
##
##plt.plot(fpr["macro"], tpr["macro"],
##         label='macro-average ROC curve (area = {0:0.2f})'
##               ''.format(roc_auc["macro"]),
##         color='navy', linestyle=':', linewidth=4)
##
##colors = cycle(['aqua', 'darkorange', 'cornflowerblue'])
##for i, color in zip(range(n_classes), colors):
##    plt.plot(fpr[i], tpr[i], color=color, lw=lw,
##             label='ROC curve of class {0} (area = {1:0.2f})'
##             ''.format(i, roc_auc[i]))
##
##plt.plot([0, 1], [0, 1], 'k--', lw=lw)
##plt.xlim([0.0, 1.0])
##plt.ylim([0.0, 1.05])
##plt.xlabel('False Positive Rate')
##plt.ylabel('True Positive Rate')
##plt.title('Some extension of Receiver operating characteristic to multi-class')
##plt.legend(loc="lower right")
##plt.show()
##
##def plot_learning_curve(estimator, title, X, y, ylim=None, cv=None,
##                        n_jobs=1, train_sizes=np.linspace(.1, 1.0, 5)):
##    """
##    Generate a simple plot of the test and training learning curve.
##
##    Parameters
##    ----------
##    estimator : object type that implements the "fit" and "predict" methods
##        An object of that type which is cloned for each validation.
##
##    title : string
##        Title for the chart.
##
##    X : array-like, shape (n_samples, n_features)
##        Training vector, where n_samples is the number of samples and
##        n_features is the number of features.
##
##    y : array-like, shape (n_samples) or (n_samples, n_features), optional
##        Target relative to X for classification or regression;
##        None for unsupervised learning.
##
##    ylim : tuple, shape (ymin, ymax), optional
##        Defines minimum and maximum yvalues plotted.
##
##    cv : int, cross-validation generator or an iterable, optional
##        Determines the cross-validation splitting strategy.
##        Possible inputs for cv are:
##          - None, to use the default 3-fold cross-validation,
##          - integer, to specify the number of folds.
##          - An object to be used as a cross-validation generator.
##          - An iterable yielding train/test splits.
##
##        For integer/None inputs, if ``y`` is binary or multiclass,
##        :class:`StratifiedKFold` used. If the estimator is not a classifier
##        or if ``y`` is neither binary nor multiclass, :class:`KFold` is used.
##
##        Refer :ref:`User Guide <cross_validation>` for the various
##        cross-validators that can be used here.
##
##    n_jobs : integer, optional
##        Number of jobs to run in parallel (default 1).
##    """
##    plt.figure()
##    plt.title(title)
##    if ylim is not None:
##        plt.ylim(*ylim)
##    plt.xlabel("Training examples")
##    plt.ylabel("Score")
##    train_sizes, train_scores, test_scores = learning_curve(
##        estimator, X, y, cv=cv, n_jobs=n_jobs, train_sizes=train_sizes)
##    train_scores_mean = np.mean(train_scores, axis=1)
##    train_scores_std = np.std(train_scores, axis=1)
##    test_scores_mean = np.mean(test_scores, axis=1)
##    test_scores_std = np.std(test_scores, axis=1)
##    plt.grid()
##
##    plt.fill_between(train_sizes, train_scores_mean - train_scores_std,
##                     train_scores_mean + train_scores_std, alpha=0.1,
##                     color="r")
##    plt.fill_between(train_sizes, test_scores_mean - test_scores_std,
##                     test_scores_mean + test_scores_std, alpha=0.1, color="g")
##    plt.plot(train_sizes, train_scores_mean, 'o-', color="r",
##             label="Training score")
##    plt.plot(train_sizes, test_scores_mean, 'o-', color="g",
##             label="Cross-validation score")
##
##    plt.legend(loc="best")
##    return plt
##
##
##title = "Learning Curves (MLP)"
##
##plot_learning_curve(mlp, title, X, y, ylim=(0.7, 1.01), cv=stratified_k_fold)
##
##plt.show()
##
