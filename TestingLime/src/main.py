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

imp=Imputer(missing_values='NaN',strategy='mean',axis=0)

np.random.seed(1)
allData = pd.read_csv("/home/ubuntu/vboxshare/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/Characteristics_GDDA_AgainstControl_ToClassify_24_04_2017.csv", sep=';')
allDataAsMatrix = allData.as_matrix();
selectedChar = np.array([47, 19, 17, 16, 18, 50, 26], dtype=np.intp);
selectedChar = selectedChar - 1 #Because it starts at 0
columNames = allData.columns.values[8:];
columNames = columNames[selectedChar.tolist()];
columNames.tolist()
#selectedChar = 1:59;
onlyData = allDataAsMatrix[:, 8:]
labels = allData['Risk']
categoricalLabels = [0] * labels.size
categoricalLabelsFinal = [];
onlyDataFinal = [];

for numLabel in xrange(1, labels.size):
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
rf = sklearn.ensemble.RandomForestClassifier(n_estimators=500)
trainNoNaNs = imp.fit_transform(train)
rf.fit(trainNoNaNs, labels_train)
sklearn.metrics.accuracy_score(labels_test, rf.predict(test))
explainer = lime.lime_tabular.LimeTabularExplainer(trainNoNaNs, feature_names=columNames, class_names=['NoRisk', 'HighRisk'], discretize_continuous=True)


for x in xrange(1,len(test)):
	exp = explainer.explain_instance(test[x], rf.predict_proba, num_features=len(selectedChar))
	#exp.show_in_notebook(show_table=True, show_all=True)
	exp.save_to_file('../results/explanationOfTest' + str(x) +'.html')

for x in xrange(1,len(train)):
	exp = explainer.explain_instance(trainNoNaNs[x], rf.predict_proba, num_features=len(selectedChar))
	#exp.show_in_notebook(show_table=True, show_all=True)
	exp.save_to_file('../results/explanationOfTrain' + str(x) +'.html')