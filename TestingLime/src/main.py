from __future__ import print_function
import sklearn
import sklearn.datasets
import sklearn.ensemble
import numpy as np
import lime
import lime.lime_tabular
import pandas as pd
import math
from sklearn.preprocessing import Imputer
from IPython.display import display, HTML

import matplotlib
import numpy as np
import matplotlib.pyplot as plt

# Adapted from https://marcotcr.github.io/lime/tutorials/Tutorial%20-%20continuous%20and%20categorical%20features.html
# https://github.com/marcotcr/lime
# You should use jupyter notebook and execute main.ipynb 
#
# Developed by Pablo Vicente-Munuera

imp=Imputer(missing_values='NaN',strategy='mean',axis=0)

np.random.seed(1)
allData = pd.read_csv("/home/ubuntu/vboxshare/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_ToClassify_24_04_2017.csv", sep=';')
allDataAsMatrix = allData.as_matrix();
selectedChar = np.array([47, 19, 17, 16, 18, 50, 26], dtype=np.intp);
selectedChar = selectedChar - 1 #Because it starts at 0
columNames = allData.columns.values[7:];
columNames = columNames[selectedChar.tolist()];
#selectedChar = 1:59;
onlyData = allDataAsMatrix[:, 7:]
labels = allData['Risk']
categoricalLabels = [0] * labels.size
categoricalLabelsFinal = [];
onlyDataFinal = [];

for numLabel in xrange(0, labels.size):
	if labels[numLabel] == 'HR' or labels[numLabel] == 'UHR':
		categoricalLabels[numLabel] = 1
		onlyDataFinal.append(onlyData[numLabel, selectedChar.tolist()])
		categoricalLabelsFinal.append(categoricalLabels[numLabel])
	elif labels[numLabel] != labels[numLabel]: #This is a NaN! wtf!?
		categoricalLabels[numLabel] = -1
	else:
		onlyDataFinal.append(onlyData[numLabel, selectedChar.tolist()])
		categoricalLabelsFinal.append(categoricalLabels[numLabel])



train, test, labels_train, labels_test = sklearn.model_selection.train_test_split(onlyDataFinal, categoricalLabelsFinal, train_size=0.80)
#http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html#sklearn.linear_model.LogisticRegression
rf = sklearn.linear_model.LogisticRegression();
#rf = sklearn.ensemble.RandomForestClassifier(n_estimators=500)
trainNoNaNs = imp.fit_transform(train)
rf.fit(trainNoNaNs, labels_train)
print('MSError when predicting the mean mean', np.mean((np.asarray(labels_train).mean() - labels_test) ** 2))
print('Logistic Regression MSError', np.mean((rf.predict(test) - labels_test) ** 2))
print('Accuracy of predicted test: ', sklearn.metrics.accuracy_score(labels_test, rf.predict(test)))
explainer = lime.lime_tabular.LimeTabularExplainer(trainNoNaNs, feature_names=columNames, class_names=['NoRisk', 'HighRisk'], discretize_continuous=True)
#exp = explainer.explain_instance(test[0], rf.predict_proba, num_features=len(selectedChar))

# Exporting all the output info to pdfs and htmls
for x in xrange(0,len(test)):
	exp = explainer.explain_instance(test[x], rf.predict_proba, num_features=len(selectedChar))
	fig = exp.as_pyplot_figure()
	fig.savefig('../results/explanationOfTest' + str(x) + '_RealLabel_' + ('HighRisk' if labels_test[x] else 'NoRisk') + '.pdf', bbox_inches='tight')
	exp.save_to_file('../results/explanationOfTest' + str(x) + '_RealLabel_' + ('HighRisk' if labels_test[x] else 'NoRisk') + '.html')

for x in xrange(0,len(train)):
	exp = explainer.explain_instance(trainNoNaNs[x], rf.predict_proba, num_features=len(selectedChar))
	fig = exp.as_pyplot_figure()
	fig.savefig('../results/explanationOfTrain' + str(x) + '_RealLabel_' + ('HighRisk' if labels_train[x] else 'NoRisk') + '.pdf', bbox_inches='tight')
	exp.save_to_file('../results/explanationOfTrain' + str(x) + '_RealLabel_' + ('HighRisk' if labels_train[x] else 'NoRisk') + '.html')