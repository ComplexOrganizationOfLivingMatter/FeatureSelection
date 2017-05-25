from __future__ import print_function
import sklearn
import sklearn.datasets
import sklearn.ensemble
import numpy as np
import lime
import lime.lime_tabular
import pandas as pd
import math

allData = pd.read_csv("/home/ubuntu/vboxshare/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_ToClassify_24_04_2017.csv", sep=';')
allDataAsMatrix = allData.as_matrix();
onlyData = allDataAsMatrix[:, 8:]
labels = allData['Risk']
categoricalLabels = [0] * labels.size
usefulRows = [];

for numLabel in xrange(1, labels.size):
	if labels[numLabel] == 'HR' or labels[numLabel] == 'UHR':
		categoricalLabels[numLabel] = 1
		usefulRows.append(numLabel)
	elif labels[numLabel] != labels[numLabel]: #This is a NaN! wtf!?
		categoricalLabels[numLabel] = -1
	else:
		usefulRows.append(numLabel)

print(usefulRows)
onlyData = onlyData[usefulRows, :]
categoricalLabels = categoricalLabels[usefulRows]

# train, test, labels_train, labels_test = sklearn.model_selection.train_test_split(onlyData, categoricalLabels, train_size=0.80)


# data = np.genfromtxt('/Users/marcotcr/phd/datasets/mushroom/agaricus-lepiota.data', delimiter=',', dtype='<U20')
# labels = data[:,0]
# le= sklearn.preprocessing.LabelEncoder()
# le.fit(labels)
# labels = le.transform(labels)
# class_names = le.classes_
# data = data[:,1:]