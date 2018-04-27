#Based on the pipeline of Juan Francisco Martín-Rodríguez

#Source functions
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/dicotomizeVariables.R', echo=TRUE)
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/univariateAnalysis.R', echo=TRUE)


#Import data
library(readxl)
initialInfo <- read_excel("D:/Pablo/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_11_01_2018.xlsx")

dependentCategory <- "Instability"

riskCalculatedLabels <- initialInfo[,dependentCategory];

initialIndex <- 41;

## First step: Dicotomize variables
#Option 1: Younden's Index
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "MaxSpSe")

#Option 2: Median
initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "Median")

#Option 3: third quartile
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "3rdQuartile")

#Option 4: Divide by quartiles
initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "Quartiles")

if (dependentCategory == "Instability"){
  initialInfoDicotomized[, dependentCategory] <- as.numeric(initialInfoDicotomized[, dependentCategory] == 'High')
} else {
  initialInfoDicotomized[, dependentCategory]  <- as.numeric(initialInfoDicotomized[, dependentCategory] == 'HighRisk')
}

## Second step: Univariate analysis to remove non-significant variables

pValueThreshold <- 0.011;

significantCharacteristics <- univariateAnalysis(initialInfoDicotomized, initialIndex, dependentCategory);

colNamesOfFormula <- paste(colnames(characteristicsWithoutClinicVTN), collapse='` + `' );
initialFormula <- as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep=''))
initialGLM <- glm(initialFormula, data=initialInfoDicotomized, family = binomial(logit))
summary(initialGLM)

## Third step: Multiple logistic regression with all the variables
#https://rstudio-pubs-static.s3.amazonaws.com/2897_9220b21cfc0c43a396ff9abf122bb351.html

significantAndClinicChars <- cbind(significantCharacteristics, characteristicsOnlyClinic)
colNamesOfFormula <- paste(names(significantAndClinicChars), collapse='` + `' );
formula <- paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep='');
allSignificantGLM <- glm(formula, data=initialInfoDicotomized, family = binomial(logit))
summary(allSignificantGLM)

require(leaps)
library(bestglm)
lbw.for.best.logistic <-
  cbind(significantAndClinicChars, initialInfoDicotomized[1:length(initialInfoDicotomized), dependentCategory])
res.best.logistic <-
  bestglm(Xy = lbw.for.best.logistic,
          family = binomial,          # binomial family for logistic
          IC = "AIC",                 # Information criteria for
          TopModels = 10,
          method = "exhaustive")

res.best.logistic$BestModels
res.best.logistic$Subsets
summary.bestglm <- res.best.logistic$BestModels;


anovaRes <- anova(res.best.logistic$BestModel, test='Chisq')
anovaRes$`Pr(>Chi)`[2]

bestCharacteristics_Method1 = res.best.logistic$BestModel$model[, 2:length(res.best.logistic$BestModel$model)];
#Refined, because we found these similarities:
# 2) MYCN and SCAs. Removing SCAs
# 3) VTN++ - eulerNumberPerFilledCell and VTN - Ratio of Strong-Positive pixels to total pixels ???? #This collinearity is low
#   3.1) We tested which to remove if any. We should remove the latter, because the first is more informative.
# 4) Histocat and Histodif. Removing HistoDif
bestCharacteristics_Method1 <- bestCharacteristics_Method1[, c(1, 3, 4, 6, 8)]

# Another method
library(glmulti)
significantAndClinicCharsWithoutColNames <- significantAndClinicChars;
xnam <- paste0("x", 1:length(significantAndClinicChars))

colnames(significantAndClinicCharsWithoutColNames) <- xnam
newFormulaWithoutNames <- as.formula(paste(dependentCategory, "~", paste(xnam, collapse= "+")))
  
# Weird variables were not allowed, so we need to transform them into variables without spaces.
# We decided to transform them into x and the number of column (x1, x2, ...)
glmulti.logistic.out <-
  glmulti(newFormulaWithoutNames, data = as.data.frame(cbind(significantAndClinicCharsWithoutColNames, initialInfoDicotomized[, dependentCategory])),
          level = 1,               # No interaction considered
          method = "h",            # Exhaustive approach
          crit = "aic",            # AIC as criteria
          confsetsize = 5,         # Keep 5 best models
          plotty = F, report = F,  # No plot or interim reports
          fitfunction = "glm",     # glm function
          family = binomial)


#Best model
glmulti.logistic.out@objects[[1]]
#5 best models
glmulti.logistic.out@formulas

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
bestCharacteristics_Method2 <- significantAndClinicChars[,c(1, 3, 8, 9, 10:15)]
#Refined, because we found these similarities:
# 1) 
# 2) MYCN and SCAs. Removing SCAs
# 3)  ???? #This collinearity is low
# 4) Histocat and Histodif. Removing HistoDif
bestCharacteristics_Method2 <- significantAndClinicChars[,c(3, 10:12, 15)]

## Forth step: Check collinearity and confusion/interaction

bestCharacteristics <- bestCharacteristics_Method2

# Collinearity
colNamesOfFormula <- paste(colnames(bestCharacteristics), collapse='` + `' );
finalFormula <- as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep=''))
vif(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)))

summary(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)))
anovaRes <- anova(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), test='Chisq')
anovaRes$`Pr(>Chi)`[2]


# Confusion and Interaction
#https://www.statmethods.net/stats/frequencies.html
mytable <- xtabs(finalFormula, data=initialInfoDicotomized)
ftable(mytable) # print table 
summary(mytable) # chi-square test of indepedence 

## Fifth step: Calculate the relative importance of each predictor within the model
# library(relaimpo) #Only for linear models... Not Logistic regression
# calc.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rela=T)
# #Boostrapping 
# boot <- boot.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rank = TRUE, 
#                     diff = TRUE, rela = TRUE)
# booteval.relimp(boot)
# plot(booteval.relimp(boot,sort=TRUE))

library(relimp)
allNumChars <- 1:length(bestCharacteristics)
relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), set1 = allNumChars[-4], set=allNumChars)

#https://www.researchgate.net/post/How_do_I_calculate_age_contribution_of_a_predictor_variable_for_logistic_regression_Have_used_varImp_function_but_it_does_not_give_percentage
#In logistic regression, the log likelihood statistic can be used for comparison of nested models. 
#So, run the full model (all IVs), and note the -2LL value (in general, smaller is better for this value). 
#Then, run successive models, each omitting one of the IVs.  The omit-one run which results in the largest 
# increase in log likelihood indicates the (omitted) IV that contributed most (given the other IVs) to the model.  
#There are no guarantees, of course, that the same sequence of 'impact' would be observed in another sample.

library(rcompanion)
require(lmtest)

colNamesOfFormula <- paste(colnames(bestCharacteristics), collapse='` + `' );
finalFormula <- as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep=''))
finalGLM <- glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit));
referenceGLM <- nagelkerke(finalGLM)

results.glmWithoutActualChar <- c()
results.glmWithoutActualChar.negelker <- c();
results.comparisonWithReference <- c();
for (numChar in 1:length(bestCharacteristics)){
  actualDF <- bestCharacteristics
  actualDF <- actualDF[-numChar]
  colNamesOfFormula <- paste(colnames(actualDF), collapse='` + `' );
  finalFormula <- as.formula(paste(dependentCategory, " ~ `", colNamesOfFormula, "`", sep=''))
  actualGLM <- glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit))
  actualNagelkerke <- nagelkerke(actualGLM);
  results.glmWithoutActualChar[numChar] <- actualNagelkerke
  results.glmWithoutActualChar.negelker[numChar] <- actualNagelkerke$Pseudo.R.squared.for.model.vs.null[3]
  # comparison <- lrtest(finalGLM, actualGLM)
  # results.comparisonWithReference[numChar] <- comparison$LogLik[2];
  #anova(my.mod1, my.mod2, test="LRT")
}

barplot(referenceGLM$Pseudo.R.squared.for.model.vs.null[3] - results.glmWithoutActualChar.negelker)


