#Based on the pipeline of Juan Francisco Martín-Rodríguez

#Source functions
debugSource('D:/Pablo/FeatureSelection/FeatureSelection/src/dicotomizeVariables.R', echo=TRUE)



#Import data
library(readxl)
initialInfo <- read_excel("D:/Pablo/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_11_01_2018.xlsx")

#riskCalculatedLabels <- cut(initialInfo$RiskCalculated, breaks=c(-Inf, 0.5, 0.6, Inf), labels=c("low","middle","high"))
riskCalculatedLabels <- initialInfo$RiskCalculated;

initialIndex <- 41;

## First step: Dicotomize variables
#Option 1: Younden's Index
initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "MaxSpSe")
initialInfoDicotomized$RiskCalculatedDicotomized <- as.numeric(initialInfoDicotomized$RiskCalculated == 'HighRisk')

#Option 2: Median

#Option 3: third quartile

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

## Third step: Multiple logistic regression with all the variables

significantAndClinicChars <- cbind(significantCharacteristics, characteristicsOnlyClinic)
colNamesOfFormula <- paste(names(significantAndClinicChars), collapse='` + `' );
formula <- paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep='')

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
          method = "exhaustive")

res.best.logistic$BestModels
summary(res.best.logistic$BestModel)

anovaRes <- anova(res.best.logistic$BestModel, test='Chisq')
anovaRes$`Pr(>Chi)`[2]

library(car)
layout(matrix(1:2, ncol = 2))

res.legend <-
  subsets(res.best.logistic, statistic="adjr2", legend = FALSE, min.size = 5, main = "Adjusted R^2")

library(glmulti)
glmulti.logistic.out <-
  glmulti(as.formula(formula), data = initialInfoDicotomized,
          level = 1,               # No interaction considered
          method = "h",            # Exhaustive approach
          crit = "aic",            # AIC as criteria
          confsetsize = 5,         # Keep 5 best models
          plotty = F, report = F,  # No plot or interim reports
          fitfunction = "glm",     # glm function
          family = binomial) 


## Forth step: Check collinearity and confusion/interaction

# Collinearity
colNamesOfFormula <- paste(colnames(res.best.logistic$BestModel$model[, 2:length(res.best.logistic$BestModel$model)]), collapse='` + `' );
finalFormula <- as.formula(paste("RiskCalculatedDicotomized ~ `", colNamesOfFormula, "`", sep=''))
vif(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)))


# Confusion and Interaction
xtabs(finalFormula, data=initialInfoDicotomized)

## Fifth step: Calculate the relative importance of each predictor within the model
library(relaimpo)
calc.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rela=T)

#Boostrapping 
boot <- boot.relimp(glm(finalFormula, data=initialInfoDicotomized, family = binomial(logit)), rank = TRUE, 
                    diff = TRUE, rela = TRUE)

booteval.relimp(boot)

plot(booteval.relimp(boot,sort=TRUE))