#Based on the pipeline of Juan Francisco Martín-Rodríguez

#Source functions
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/dicotomizeVariables.R', echo=TRUE)



#Import data
library(readxl)
initialInfo <- read_excel("D:/Pablo/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_11_01_2018.xlsx")

riskCalculatedLabels <- initialInfo$RiskCalculated;

initialIndex <- 41;

## First step: Dicotomize variables
#Option 1: Younden's Index
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "MaxSpSe")

#Option 2: Median
#initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "Median")

#Option 3: third quartile
initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "3rdQuartile")


initialInfoDicotomized$RiskCalculatedDicotomized <- as.numeric(initialInfoDicotomized$RiskCalculated == 'HighRisk')

## Second step: Univariate analysis to remove non-significant variables
require(rms)

characteristicsAll <- initialInfoDicotomized[, initialIndex:length(initialInfo[1,])];
characteristicsWithoutClinic <- initialInfoDicotomized[,initialIndex:(length(initialInfo[1,])-8)];
characteristicsOnlyClinic <- initialInfoDicotomized[,(length(initialInfo[1,])-7):length(initialInfo[1,])];

characteristicsWithoutClinicVTN <- characteristicsWithoutClinic[,grepl( "VTN" , colnames(characteristicsWithoutClinic) )]

univariateAnalysisPvalues <- lapply(colnames(characteristicsWithoutClinicVTN),
       
       function(var) {
         
         formula    <- as.formula(paste("RiskCalculatedDicotomized ~ `", var, '`', sep=''))
         res.logist <- glm(formula, data = initialInfoDicotomized, family = binomial(logit))
         anovaRes <- anova(res.logist,test='Chisq')
         anovaRes$`Pr(>Chi)`[2]
       })

univariateAnalysisPvalues[is.na(univariateAnalysisPvalues)] = 1;

pValueThreshold = 0.01;
significantCharacteristics <- characteristicsWithoutClinicVTN[,univariateAnalysisPvalues < pValueThreshold]

colNamesOfFormula <- paste(colnames(characteristicsWithoutClinicVTN), collapse='` + `' );
initialFormula <- as.formula(paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep=''))
initialGLM <- glm(initialFormula, data=initialInfoDicotomized, family = binomial(logit))
summary(initialGLM)

## Third step: Multiple logistic regression with all the variables

significantAndClinicChars <- cbind(significantCharacteristics, characteristicsOnlyClinic)
colNamesOfFormula <- paste(names(significantAndClinicChars), collapse='` + `' );
formula <- paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep='');
allSignificantGLM <- glm(formula, data=initialInfoDicotomized, family = binomial(logit))
summary(allSignificantGLM)


#library(leaps)
#leapsResults <- regsubsets(RiskCalculatedDicotomized ~ `VTN++ - meanPercentageOfFibrePerFilledCell` + `VTN++ - stdPercentageOfFibrePerFilledCell` + `VTN++ - meanQuantityOfBranchesFilledPerCell` + `VTN++ - eulerNumberPerFilledCell` + `INRG_EDAD` + `INRG_ESTADIO` + `INRG_HistoCat` + `INRG_HistoDif` + `INRG_SCA` + `INRG_MYCN` + `INRG_PLOIDIA` + `INRG_11q`, data = initialInfoDicotomized, nbest= 1, nvmax = NULL, force.in = NULL, force.out = NULL, method = "exhaustive")
#summary.leaps<-summary(leapsResults)
#plot(summary.leaps, scale = "adjr2", main = "Adjusted R^2")

require(leaps)
library(bestglm)
lbw.for.best.logistic <-
  cbind(significantAndClinicChars, initialInfoDicotomized$RiskCalculatedDicotomized)
res.best.logistic <-
  bestglm(Xy = lbw.for.best.logistic,
          family = binomial,          # binomial family for logistic
          IC = "AIC",                 # Information criteria for
          TopModels = 10,
          method = "exhaustive")

res.best.logistic$BestModels
summary(res.best.logistic$BestModel)

anovaRes <- anova(res.best.logistic$BestModel, test='Chisq')
anovaRes$`Pr(>Chi)`[2]

library(car)
layout(matrix(1:2, ncol = 2))

res.legend <-
  subsets(res.best.logistic, statistic="adjr2", legend = FALSE, min.size = 5, main = "Adjusted R^2")


# Another method
library(glmulti)
significantAndClinicCharsWithoutColNames <- significantAndClinicChars;
xnam <- paste0("x", 1:length(significantAndClinicChars))

colnames(significantAndClinicCharsWithoutColNames) <- xnam
newFormulaWithoutNames <- as.formula(paste("initialInfoDicotomized$RiskCalculatedDicotomized ~ ", paste(xnam, collapse= "+")))
  
# Weird variables were not allowed, so we need to transform them into variables without spaces.
# We decided to transform them into x and the number of column (x1, x2, ...)
glmulti.logistic.out <-
  glmulti(newFormulaWithoutNames, data = as.data.frame(cbind(significantAndClinicCharsWithoutColNames, initialInfoDicotomized$RiskCalculatedDicotomized)),
          level = 1,               # No interaction considered
          method = "h",            # Exhaustive approach
          crit = "aic",            # AIC as criteria
          confsetsize = 5,         # Keep 5 best models
          plotty = F, report = F,  # No plot or interim reports
          fitfunction = "glm",     # glm function
          family = binomial) 


bestCharacteristics = res.best.logistic$BestModel$model[, 2:length(res.best.logistic$BestModel$model)];

## Forth step: Check collinearity and confusion/interaction

# Collinearity
colNamesOfFormula <- paste(colnames(bestCharacteristics), collapse='` + `' );
finalFormula <- as.formula(paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep=''))
vif(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)))


# Confusion and Interaction
mytable <- xtabs(finalFormula, data=initialInfoDicotomized)
ftable(mytable) # print table 
summary(mytable) # chi-square test of indepedence 

## Fifth step: Calculate the relative importance of each predictor within the model
library(relaimpo) #Only for linear models... Not Logistic regression
calc.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rela=T)
#Boostrapping 
boot <- boot.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rank = TRUE, 
                    diff = TRUE, rela = TRUE)
booteval.relimp(boot)
plot(booteval.relimp(boot,sort=TRUE))

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
finalFormula <- as.formula(paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep=''))
finalGLM <- glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit));
referenceGLM <- nagelkerke(finalGLM)

results.glmWithoutActualChar <- c()
results.glmWithoutActualChar.negelker <- c();
results.comparisonWithReference <- c();
for (numChar in 1:length(bestCharacteristics)){
  actualDF <- bestCharacteristics
  actualDF <- actualDF[-numChar]
  colNamesOfFormula <- paste(colnames(actualDF), collapse='` + `' );
  finalFormula <- as.formula(paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep=''))
  actualGLM <- glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit))
  actualNagelkerke <- nagelkerke(actualGLM);
  results.glmWithoutActualChar[numChar] <- actualNagelkerke
  results.glmWithoutActualChar.negelker[numChar] <- actualNagelkerke$Pseudo.R.squared.for.model.vs.null[3]
  comparison <- lrtest(finalGLM, actualGLM)
  results.comparisonWithReference[numChar] <- comparison$LogLik[2];
  anova(my.mod1, my.mod2, test="LRT")
}

referenceGLM$Pseudo.R.squared.for.model.vs.null[3] - results.glmWithoutActualChar.negelker


