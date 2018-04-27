#Based on the pipeline of Juan Francisco Martín-Rodríguez

rm(list = setdiff(ls(), lsf.str()))

#Source functions
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/dicotomizeVariables.R',
            echo = TRUE)
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/univariateAnalysis.R',
            echo = TRUE)


#Import data
library(readxl)
initialInfo <-
  read_excel(
    "D:/Pablo/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_11_01_2018.xlsx"
  )

dependentCategory <- "RiskCalculated" #"Instability" or "RiskCalculated"
outputFile <- paste("outputResults", dependentCategory, format(Sys.time(), "%d-%m-%Y"),".txt", sep='_')


initialIndex <- 41

sink(temporaryFileObj <- textConnection("outputFileText", "w"), split=TRUE)

## First step: Dicotomize variables
print("-------------First step: Dicotomize variables---------------")
#Option 1: Younden's Index
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "MaxSpSe")

#Option 2: Median
# initialInfoDicotomized <-
#   dicotomizeVariables(initialInfo,
#                       initialIndex,
#                       "RiskCalculated",
#                       dependentCategory,
#                       "Median")

#Option 3: third quartile
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "3rdQuartile")

#Option 4: Divide by quartiles
initialInfoDicotomized <-
  dicotomizeVariables(initialInfo,
                      initialIndex,
                      dependentCategory,
                      "NoRisk",
                      "Quartiles")

initialInfoDicotomized <- initialInfoDicotomized[is.na(initialInfoDicotomized[, dependentCategory]) == 0,];
riskCalculatedLabels <- initialInfoDicotomized[, dependentCategory]
if (dependentCategory == "Instability") {
  initialInfoDicotomized[, dependentCategory] <-
    as.numeric(initialInfoDicotomized[, dependentCategory] == 'High')
} else {
  initialInfoDicotomized[, dependentCategory]  <-
    as.numeric(initialInfoDicotomized[, dependentCategory] == 'HighRisk')
}


print('-----------------------------')

## Second step: Univariate analysis to remove non-significant variables

print("-------------Second step: Univariate analysis to remove non-significant variables---------------")

#P-Values for categories:
#RiskCalculated = 0.011
#Instability = 0.05 or 0.00001
pValueThreshold <- 0.018

characteristicsAll <-
  initialInfoDicotomized[, initialIndex:length(initialInfoDicotomized[1,])]

characteristicsWithoutClinic <-
  initialInfoDicotomized[, initialIndex:(length(initialInfoDicotomized[1,]) -
                                           8)]

characteristicsOnlyClinic <-
  initialInfoDicotomized[, (length(initialInfoDicotomized[1,]) - 7):length(initialInfoDicotomized[1,])]


characteristicsWithoutClinicVTN <-
  characteristicsWithoutClinic[, grepl("VTN" , colnames(characteristicsWithoutClinic))]

#Only our new features
characteristicsWithoutClinicVTN <- characteristicsWithoutClinicVTN[, 1:32];

bestVTNMorphometricsFeatures <- c(109, 108, 110, 112, 118, 119, 120, 122);


significantCharacteristics <-
  univariateAnalysis(initialInfoDicotomized, initialIndex, dependentCategory, characteristicsWithoutClinicVTN, pValueThreshold)


colNamesOfFormula <-
  paste(colnames(characteristicsWithoutClinicVTN), collapse = '` + `')

initialFormula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                     ''))
initialGLM <-
  glm(initialFormula, data = initialInfoDicotomized, family = binomial(logit))
summary(initialGLM)

print('-----------------------------')

## Third step: Multiple logistic regression with all the variables
#https://rstudio-pubs-static.s3.amazonaws.com/2897_9220b21cfc0c43a396ff9abf122bb351.html

print("-------------Third step: Multiple logistic regression with all the variables---------------")

#Method 1: bestglm
significantAndClinicChars <-
  cbind(significantCharacteristics, characteristicsOnlyClinic)
colNamesOfFormula <-
  paste(names(significantAndClinicChars), collapse = '` + `')

formula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep = ''))

allSignificantGLM <-
  glm(formula, data = initialInfoDicotomized, family = binomial(logit))
summary(allSignificantGLM)

#We have also added an independent standard Gaussian random variable to the
#model matrix as a redundant variable (RV). This provides a baseline to help
#determine which inclusion probabilities are "significant" in the sense that
#they exhibit a different behaviour to the RV curve.
vis.glm = vis(allSignificantGLM, B = 100, redundant = TRUE, nbest = 5, cores = 8); #nbest also ="all"
"Vis output"
print(vis.glm, min.prob = 0.2)
png(paste('boostrapVariablesProbability', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'), width = 1200, height = 500)
plot(vis.glm, interactive = FALSE, which="vip")
dev.off()
#plot(vis.glm, interactive = FALSE, which="boot") #HighLight to change the reference variable
#plot(vis.glm, interactive = FALSE, which="lvk")

bestCharacteristics_Method1 <-
  logisticFeatureSelection(significantAndClinicChars,
                           initialInfoDicotomized,
                           dependentCategory,
                           "method1")

#-------------RiskCalculated----------------#
#Refined, because we found these similarities:
# 2) MYCN and SCAs. Removing SCAs
# 3) VTN++ - eulerNumberPerFilledCell and VTN - Ratio of Strong-Positive pixels to total pixels ???? #This collinearity is low
#   3.1) We tested which to remove if any. We should remove the latter, because the first is more informative.
# 4) Histocat and Histodif. Removing HistoDif
bestCharacteristics_Method1 <-
  bestCharacteristics_Method1[, c(1, 3, 4, 6, 8)]

#Method2: glmulti
bestCharacteristics_Method2 <-
  logisticFeatureSelection(significantAndClinicChars,
                           initialInfoDicotomized,
                           dependentCategory,
                           "method2")
#Before found collinearities
# #For Option 3: 3rd Quartile
# bestCharacteristics_Method2 <- significantAndClinicChars[,c(1, 2, 8, 10:16)]
# #Refined, because we found these similarities:
# # 1) VTN - Total cells and H-Score. Removin H-Score
# # 2) MYCN and SCAs. Removing SCAs
# # 3) VTN - Total cells and VTN++ - meanQuantityOfBranchesFilledPerCell ???? #This collinearity is low
# # 4) Histocat and Histodif. Removing HistoDif
# bestCharacteristics_Method2 <- significantAndClinicChars[,c(1, 8, 11:13, 16)]
#For Option 4: Quartiles
bestCharacteristics_Method2 <-
  significantAndClinicChars[, c(1, 3, 8, 9, 10:15)]
#Refined, because we found these similarities:
# 1)
# 2) MYCN and SCAs. Removing SCAs
# 3)  ???? #This collinearity is low
# 4) Histocat and Histodif. Removing HistoDif
bestCharacteristics_Method2 <-
  significantAndClinicChars[, c(3, 10:12, 15)]

#-------------END----------------#

#-------------INSTABILITY----------------#
#From mplot
bestCharacteristics_Method1 <- significantAndClinicChars[, c(1, 4, 6, 8, 10)]


#-------------END----------------#

print('-----------------------------')

## Forth step: Check collinearity and confusion/interaction

print("-------------Forth step: Check collinearity and confusion/interaction---------------")

bestCharacteristics <- bestCharacteristics_Method1

# Collinearity

library(car)
colNamesOfFormula <-
  paste(colnames(bestCharacteristics), collapse = '` + `')

finalFormula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                     ''))
print('Checking collinearity:')
vif(glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit)))

print('-----------------------------')

# Confusion and Interaction
print("Confusion and interaction")
#https://www.statmethods.net/stats/frequencies.html
mytable <- xtabs(finalFormula, data = initialInfoDicotomized)
#ftable(mytable) # print table
summary(mytable) # chi-square test of indepedence

print('-----------------------------')

## Fifth step: Calculate the relative importance of each predictor within the model

print("-------------Fifth step: Calculate the relative importance of each predictor within the model---------------")

# library(relaimpo) #Only for linear models... Not Logistic regression
# calc.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rela=T)
# #Boostrapping
# boot <- boot.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rank = TRUE,
#                     diff = TRUE, rela = TRUE)
# booteval.relimp(boot)
# plot(booteval.relimp(boot,sort=TRUE))

# #Other option of seeing the relative importance
# library(relimp)
# allNumChars <- 1:length(bestCharacteristics)+1
# res.relimp <- relimp(
#   glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit)),
#   set1 = allNumChars[-1],
#   set2 = allNumChars
# )
# res.relimp

#https://www.researchgate.net/post/How_do_I_calculate_age_contribution_of_a_predictor_variable_for_logistic_regression_Have_used_varImp_function_but_it_does_not_give_percentage
#In logistic regression, the log likelihood statistic can be used for comparison of nested models.
#So, run the full model (all IVs), and note the -2LL value (in general, smaller is better for this value).
#Then, run successive models, each omitting one of the IVs.  The omit-one run which results in the largest
# increase in log likelihood indicates the (omitted) IV that contributed most (given the other IVs) to the model.
#There are no guarantees, of course, that the same sequence of 'impact' would be observed in another sample.

library(rcompanion)
require(lmtest)

colNamesOfFormula <-
  paste(colnames(bestCharacteristics), collapse = '` + `')

finalFormula <-
  as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                     ''))
finalGLM <-
  glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit))

"Final logistic regression"
summary(finalGLM)

"---"
"Anova chi square"
anovaRes <-
  anova(glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit)),
        test = 'Chisq')
anovaRes$`Pr(>Chi)`[2]


"Odds ratio"
exp(coefficients(finalGLM))
Yhat <- fitted(finalGLM)

prob=predict(finalGLM,type=c("response"))

thresh <- 0.5
YhatFac <-
  cut(Yhat,
      breaks = c(-Inf, thresh, Inf),
      labels = c("NoRisk", "HighRisk"))

cTab <- table(factor(riskCalculatedLabels[, dependentCategory], levels = c("NoRisk", "HighRisk")), YhatFac)

"Confussion matrix"
addmargins(cTab)

library(caret)
"Specificity (NoRisk)"
sensitivity(cTab)
"Sensitivity (HighRisk)"
specificity(cTab)

#Roc curve
library(pROC)

predicting$prob <- prob;
g <- roc(RiskCalculated ~ prob, data = as.data.frame(riskCalculatedLabels))
png(paste('rocCurve', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'))
plot(g)
dev.off()

referenceGLM <- nagelkerke(finalGLM)

results.glmWithoutActualChar <- c()
results.glmWithoutActualChar.negelker <- c()

results.comparisonWithReference <- c()

for (numChar in 1:length(bestCharacteristics)) {
  actualDF <- bestCharacteristics
  actualDF <- actualDF[-numChar]
  colNamesOfFormula <- paste(colnames(actualDF), collapse = '` + `')
  
  finalFormula <-
    as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep =
                       ''))
  actualGLM <-
    glm(finalFormula, data = initialInfoDicotomized, family = binomial(logit))
  actualNagelkerke <- nagelkerke(actualGLM)
  
  results.glmWithoutActualChar[numChar] <- actualNagelkerke
  results.glmWithoutActualChar.negelker[numChar] <-
    actualNagelkerke$Pseudo.R.squared.for.model.vs.null[3]
  # comparison <- lrtest(finalGLM, actualGLM)
  # results.comparisonWithReference[numChar] <- comparison$LogLik[2];
  #anova(my.mod1, my.mod2, test="LRT")
}

#Opening file to export
png(paste('barPlotOfImportance', dependentCategory, format(Sys.time(), "%d-%m-%Y"), '.png', sep = '_'), width = 1200, height = 700)
barplot(
  referenceGLM$Pseudo.R.squared.for.model.vs.null[3] - results.glmWithoutActualChar.negelker,
  names.arg = colnames(bestCharacteristics),
  ylab = "Change in Nagelkerke R^2",
  col = terrain.colors(5),
  cex.names = 0.8,
  ylim = c(0, 0.5)
)
title(paste0("Relative importance for ", dependentCategory))
dev.off()

sink()
close(temporaryFileObj)
out<-capture.output(outputFileText, file = outputFile, split = T)
