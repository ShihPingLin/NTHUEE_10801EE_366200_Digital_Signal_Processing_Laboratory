#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 28 2019

@author: Cosine
"""

from glob import glob
import os
import librosa
import numpy as np
import pandas as pd
#from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import KFold
#from sklearn.model_selection import cross_val_score
from sklearn.metrics import recall_score
from sklearn.metrics import confusion_matrix
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
#%%
DATASET_PATH = './Baby_Data'

#%% Functions
def pre_emphasis(signal,coefficient=0.95):
    return np.append(signal[0],signal[1:]-coefficient*signal[:-1])

def MFCC_feat(file):
    '''
    Please put your MFCC() function learned from lab5 here.
    '''   
    y, sr = librosa.load(file)
    y2 = pre_emphasis(y)
    
    # mfcc
    mfcc = librosa.feature.mfcc(y=y2, sr=sr, hop_length=512, htk=True)  
    feature = np.mean(mfcc, axis=1)   
    feature = np.hstack((feature, np.std(mfcc, axis = 1)))   
    feature = np.hstack((feature, np.max(mfcc, axis = 1)))
    feature = np.hstack((feature, np.min(mfcc, axis = 1)))

    return feature

def cross_val(cv, c, train_data, train_target):
    '''
    You can do cross validation here to find the best 'c' for training.
    '''
    RANDSEED = 0
    Kf = KFold(n_splits=cv, shuffle=True, random_state=RANDSEED)
    y_test_cv = []
    y_predict_cv = []
    for cvIdx, (trainIdx, testIdx) in enumerate(Kf.split(range(len(train_data)))):
        # split data into Train & Test
        X_train, X_test = train_data[trainIdx], train_data[testIdx]     
        y_train, y_test = train_target[trainIdx], train_target[testIdx]   
        # perform the same train / testing process in IRIS-TrainingTest
        clf = SVC(kernel='rbf', random_state=0, C = c)
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
    print(cm)
    print('UAR = ',  unweighted_averaged_recall) 
    
    pass

#%% Loading training and test data
train_path = sorted(glob(os.path.join(DATASET_PATH, 'wav_train', 'train*.wav')))
test_path = sorted(glob(os.path.join(DATASET_PATH, 'wav_dev', 'dev*.wav')))

train_data = [MFCC_feat(path) for path in train_path]
test_data = [MFCC_feat(path) for path in test_path]

#%% Reading labels
labels = pd.read_csv(os.path.join(DATASET_PATH, 'labels.csv'))
name2label = dict((row['file_name'], row['label']) for idx, row in labels.iterrows())
train_label = [name2label[os.path.basename(path)] for path in train_path]
test_label = [name2label[os.path.basename(path)] for path in test_path]

#%% Training SVM model
X_train = np.vstack(train_data)
y_train = np.array(train_label)
X_test = np.vstack(test_data)
y_test = np.array(test_label)

'''
Train your SVM model here.
'''
#y_predict = ?'
sc = StandardScaler()
sc.fit(X_train)
X_train_std = sc.transform(X_train)
X_test_std = sc.transform(X_test)

C_me = 0.8
model = SVC(kernel='rbf', random_state=0, C = C_me)
model.fit(X_train_std, y_train)
y_pred = model.predict(X_test_std)

#%%
#cross validation
fold = 10
cross_val(fold, C_me, X_train_std, y_train)

# Prediction and Performance Measurement for training set
X_train_me, X_test_me, y_train_me, y_test_me = train_test_split(X_train_std, y_train, test_size = 0.2, random_state = 0)

y_pred_train = model.predict(X_test_me)
print('Misclassified samples: %d' % (y_test_me != y_pred_train).sum())
from sklearn.metrics import accuracy_score
print('Accuracy: %.2f' %accuracy_score(y_test_me, y_pred_train))
print('Accuracy: %.2f' %model.score(X_test_me, y_test_me))

#%% Saving results into csv
results = pd.DataFrame({'file_name':[os.path.basename(f) for f in test_path], 'prediction':y_pred})
results.to_csv('results.csv', index=False)
