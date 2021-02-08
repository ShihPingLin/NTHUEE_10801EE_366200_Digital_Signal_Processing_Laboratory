# -*- coding: utf-8 -*-
"""
Created on Mon Oct 29 16:44:40 2018

@author: CHADSHEEP
"""

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC, LinearSVC
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
import numpy as np
import itertools
from sklearn.model_selection import KFold
from sklearn.metrics import recall_score


#%% functions
def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.savefig('./output/iris_cv.png', dpi=300)



#%%
# Parameters
RANDSEED = 1 # setupt random seed for repeatness
CVFOLD = 5 # number of folds of cross validation
c = 10

# load iris data
# Check sklearn documentation!
iris = load_iris()
X = iris.data
y = iris.target
class_names = iris.target_names


# cross validation
Kf = KFold(n_splits=CVFOLD, shuffle=True, random_state=RANDSEED)
y_test_cv = []
y_predict_cv = []
for cvIdx, (trainIdx, testIdx) in enumerate(Kf.split(range(len(X)))):
    # split data into Train & Test
    X_train, X_test = X[trainIdx], X[testIdx]     
    y_train, y_test = y[trainIdx], y[testIdx]   
    # perform the same train / testing process in IRIS-TrainingTest
    clf = LinearSVC(C=c , class_weight='balanced') 
    # Note that u have to build a new classifier too!
    clf.fit(X_train, y_train)     
    y_predict= clf.predict(X_test)
    # collect the predict results and ground truths from each folds
    y_test_cv.extend(y_test)
    y_predict_cv.extend(y_predict)
    
 
# Evaluation
unweighted_averaged_recall = recall_score(y_test_cv, y_predict_cv, average='macro')
cm = confusion_matrix(y_test_cv, y_predict_cv)

# Visulization
plot_confusion_matrix(cm , class_names)
print('UAR = ',  unweighted_averaged_recall)
