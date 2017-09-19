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

np.random.seed(1)
allData = pd.read_csv("/home/ubuntu/vboxshare/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_12_09_2017.csv", sep=';')
allDataAsMatrix = allData.as_matrix();
selectedChar = np.array([49, 53, 65, 79, 47, 22], dtype=np.intp);
selectedChar = selectedChar - 1 #Because it starts at 0
columNames = allData.columns.values[10:];
columNames = columNames[selectedChar.tolist()];
onlyData = allDataAsMatrix[:, 10:]
labels = allData['Instability']
categoricalLabels = [0] * labels.size
categoricalLabelsFinal = [];
onlyDataFinal = [];
patientNames = [];

for numLabel in xrange(0, labels.size):
	if labels[numLabel] == 'High':
		categoricalLabels[numLabel] = 1
		onlyDataFinal.append(onlyData[numLabel, selectedChar.tolist()])
		categoricalLabelsFinal.append(categoricalLabels[numLabel])
		patientNames.append(allData.Casos[numLabel])
	elif labels[numLabel] != labels[numLabel]: #This is a NaN! wtf!?
		categoricalLabels[numLabel] = -1
	else:
		onlyDataFinal.append(onlyData[numLabel, selectedChar.tolist()])
		categoricalLabelsFinal.append(categoricalLabels[numLabel])
		patientNames.append(allData.Casos[numLabel])


##Division between training and test
# train, test, labels_train, labels_test = sklearn.model_selection.train_test_split(onlyDataFinal, categoricalLabelsFinal, train_size=0.80)
# #http://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html#sklearn.linear_model.LogisticRegression
# rf = sklearn.linear_model.LogisticRegression();
# #rf = sklearn.ensemble.RandomForestClassifier(n_estimators=500)
# trainNoNaNs = imp.fit_transform(train)
# rf.fit(trainNoNaNs, labels_train)
# print('MSError when predicting the mean mean', np.mean((np.asarray(labels_train).mean() - labels_test) ** 2))
# print('Logistic Regression MSError', np.mean((rf.predict(test) - labels_test) ** 2))
# print('Accuracy of predicted test: ', sklearn.metrics.accuracy_score(labels_test, rf.predict(test)))
# explainer = lime.lime_tabular.LimeTabularExplainer(trainNoNaNs, feature_names=columNames, class_names=['NoRisk', 'HighRisk'], discretize_continuous=True)
# #exp = explainer.explain_instance(test[0], rf.predict_proba, num_features=len(selectedChar))

# # Exporting all the output info to pdfs and htmls
# for x in xrange(0,len(test)):
# 	exp = explainer.explain_instance(test[x], rf.predict_proba, num_features=len(selectedChar))
# 	fig = exp.as_pyplot_figure()
# 	fig.savefig('../results/explanationOfTest' + str(x) + '_RealLabel_' + ('HighRisk' if labels_test[x] else 'NoRisk') + '.pdf', bbox_inches='tight')
# 	exp.save_to_file('../results/explanationOfTest' + str(x) + '_RealLabel_' + ('HighRisk' if labels_test[x] else 'NoRisk') + '.html')

# for x in xrange(0,len(train)):
# 	exp = explainer.explain_instance(trainNoNaNs[x], rf.predict_proba, num_features=len(selectedChar))
# 	fig = exp.as_pyplot_figure()
# 	fig.savefig('../results/explanationOfTrain' + str(x) + '_RealLabel_' + ('HighRisk' if labels_train[x] else 'NoRisk') + '.pdf', bbox_inches='tight')
# 	exp.save_to_file('../results/explanationOfTrain' + str(x) + '_RealLabel_' + ('HighRisk' if labels_train[x] else 'NoRisk') + '.html')

#NoDivision
rf = sklearn.linear_model.LogisticRegression();
allDataNoNaNs = onlyDataFinal
rf.fit(allDataNoNaNs, categoricalLabelsFinal)
explainer = lime.lime_tabular.LimeTabularExplainer(allDataNoNaNs, feature_names=columNames, class_names=['NoRisk', 'HighRisk'])
predictedValues = rf.predict(allDataNoNaNs);
print('Accuracy of predicted test: ', sklearn.metrics.accuracy_score(categoricalLabelsFinal, predictedValues))

for x in xrange(0,len(categoricalLabelsFinal)):
    exp = explainer.explain_instance(allDataNoNaNs[x], rf.predict_proba, num_features=len(selectedChar))
    fig = exp.as_pyplot_figure()
    fig.savefig('../results/explanationOfTrain' + str(patientNames[x]) + '_RealLabel_' + ('HighRisk' if categoricalLabelsFinal[x] else 'NoRisk') + '_PredictedLabel_' + ('HighRisk' if predictedValues[x] else 'NoRisk') + '.pdf', bbox_inches='tight')
    exp.save_to_file('../results/explanationOfTrain' + str(patientNames[x]) + '_RealLabel_' + ('HighRisk' if categoricalLabelsFinal[x] else 'NoRisk') + '_PredictedLabel_' + ('HighRisk' if predictedValues[x] else 'NoRisk') + '.html')
    