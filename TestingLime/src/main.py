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
selectedChar = np.array([22, 64, 68, 25, 47, 7, 46], dtype=np.intp);
selectedChar = selectedChar - 1 #Because it starts at 0
columNames = allData.columns.values[10:];
columNames = columNames[selectedChar.tolist()];
onlyData = allDataAsMatrix[:, 10:]
labels = allData['RiskReal']
categoricalLabels = [0] * labels.size
categoricalLabelsFinal = [];
onlyDataFinal = [];
patientNames = [];

for numLabel in xrange(0, labels.size):
	if labels[numLabel] == 'HighRisk':
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
# rf = sklearn.linear_model.LogisticRegression(class_weight='balanced', solver='liblinear', penalty='l1', max_iter=100000, tol=0.00000000001)
# allDataNoNaNs = np.asarray(onlyDataFinal)
# rf.fit(allDataNoNaNs, categoricalLabelsFinal)
explainer = lime.lime_tabular.LimeTabularExplainer(np.asarray(onlyDataFinal), feature_names=columNames, class_names=['NoRisk', 'HighRisk'])
# predictedValues = rf.predict(allDataNoNaNs);
# print('Accuracy of predicted test: ', sklearn.metrics.accuracy_score(categoricalLabelsFinal, predictedValues))

predictedProbabilities = np.array([[0.0241880475361168, 0.975811952463883], 
[0.371627392549265, 0.628372607450735], 
[0.952598926545781, 0.0474010734542187], 
[0.958635683367619, 0.0413643166323809], 
[0.906119771897813, 0.0938802281021873], 
[0.177625995475787, 0.822374004524213], 
[0.0129354594120832, 0.987064540587917], 
[8.22079259757760e-05, 0.999917792074024], 
[0.0129902852452192, 0.987009714754781], 
[0.000132975187093948, 0.999867024812906], 
[0.0171533608333428, 0.982846639166657], 
[0.0295799976905867, 0.970420002309413], 
[0.0202064677866282, 0.979793532213372], 
[0.000312595032413164, 0.999687404967587], 
[0.649447806001382, 0.350552193998619], 
[0.000413542969634496, 0.999586457030366], 
[0.0106839559364261, 0.989316044063574], 
[0.0101052772129404, 0.989894722787060], 
[0.0448932419624221, 0.955106758037578], 
[0.0598051489487546, 0.940194851051246], 
[0.00955041221036146, 0.990449587789639], 
[0.000782131458422081, 0.999217868541578], 
[0.371691733768630, 0.628308266231370], 
[0.0132943224321586, 0.986705677567841], 
[3.64498853122947e-06, 0.999996355011469], 
[0.0168510176526638, 0.983148982347336], 
[0.0684907700389986, 0.931509229961001], 
[0.167167782248980, 0.832832217751020], 
[0.0578453930730657, 0.942154606926934], 
[0.219583877960213, 0.780416122039787], 
[0.00119988353372297, 0.998800116466277], 
[0.00110347748382099, 0.998896522516179], 
[0.0594794663177308, 0.940520533682269], 
[0.0294363996181109, 0.970563600381889], 
[0.326168430370100, 0.673831569629900], 
[2.85947806874419e-06, 0.999997140521931], 
[0.00142732799153654, 0.998572672008463], 
[0.00806885073555360, 0.991931149264446], 
[0.00745363379679698, 0.992546366203203], 
[0.0251640856888575, 0.974835914311143], 
[0.751827532180485, 0.248172467819515], 
[0.528855425833014, 0.471144574166986], 
[0.312905174860388, 0.687094825139612], 
[0.00343022302967531, 0.996569776970325], 
[0.799027780878188, 0.200972219121812], 
[0.534792056063751, 0.465207943936249], 
[0.00825544080273365, 0.991744559197266], 
[0.903266429290670, 0.0967335707093296], 
[0.000396473200899476, 0.999603526799101], 
[0.0810869717532202, 0.918913028246780], 
[0.00124909995294329, 0.998750900047057], 
[0.0616009131822191, 0.938399086817781], 
[0.575772955951545, 0.424227044048455], 
[0.0405032996502967, 0.959496700349703], 
[0.439942372724738, 0.560057627275262], 
[0.112428000295474, 0.887571999704526], 
[0.0912194579309503, 0.908780542069050], 
[0.00134240177808640, 0.998657598221914], 
[0.0157894117689817, 0.984210588231018], 
[0.154579017097044, 0.845420982902956], 
[0.889902187439543, 0.110097812560457], 
[0.0455347767361423, 0.954465223263858], 
[0.0792495531428746, 0.920750446857126], 
[0.190485591980664, 0.809514408019336], 
[1, 0], 
[0.518779995320919, 0.481220004679081], 
[0.00539372290945825, 0.994606277090542], 
[0.206201479665240, 0.793798520334760], 
[0.000311037939615472, 0.999688962060385], 
[0.00118060069190132, 0.998819399308099], 
[0.0612253034602632, 0.938774696539737], 
[0.00543505236572990, 0.994564947634270], 
[0.0542140928371745, 0.945785907162826], 
[0.162752848160545, 0.837247151839455], 
[5.54833332238378e-05, 0.999944516666776], 
[0.0314045682520172, 0.968595431747983], 
[0.0259132979264548, 0.974086702073545], 
[0.00132132764130297, 0.998678672358697], 
[0.0121327524329625, 0.987867247567038], 
[1.49539398213141e-05, 0.999985046060179], 
[0.000835002032720356, 0.999164997967280], 
[0.0226760551597791, 0.977323944840221], 
[0.985410509896165, 0.0145894901038346], 
[0.957911891128200, 0.0420881088718003], 
[0.730200784232641, 0.269799215767359], 
[0.928605222299696, 0.0713947777003042], 
[0.0943704004504653, 0.905629599549535], 
[0.000204461947096081, 0.999795538052904], 
[0.698216687012896, 0.301783312987104], 
[0.000739899987452490, 0.999260100012548], 
[0.226746381087853, 0.773253618912147]])

p_function = lambda x: predictedProbabilities


for x in xrange(0,len(categoricalLabelsFinal)):
    exp = explainer.explain_instance(allDataNoNaNs[x], p_function, num_features=len(selectedChar), num_samples=len(categoricalLabelsFinal))
    fig = exp.as_pyplot_figure()
    fig.savefig('../results/explanationOfTrain' + str(patientNames[x]) + '_RealLabel_' + ('HighRisk' if categoricalLabelsFinal[x] else 'NoRisk') + '.pdf', bbox_inches='tight')
    exp.save_to_file('../results/explanationOfTrain' + str(patientNames[x]) + '_RealLabel_' + ('HighRisk' if categoricalLabelsFinal[x] else 'NoRisk') + '.html')
    