#Based on the pipeline of Juan Francisco Martín-Rodríguez

#Source functions
source('D:/Pablo/FeatureSelection/FeatureSelection/src/dicotomizeVariables.R', echo=TRUE)

#Import data
library(readxl)
initialInfo <- read_excel("D:/Pablo/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_11_01_2018.xlsx")

#riskCalculatedLabels <- cut(initialInfo$RiskCalculated, breaks=c(-Inf, 0.5, 0.6, Inf), labels=c("low","middle","high"))
riskCalculatedLabels <- initialInfo$RiskCalculated;

initialIndex <- 41;

## First step: Dicotomize variables
#Option 1: Younden's Index
initialInfoDicotomized <- dicotomizeVariables(initialInfo, initialIndex, "RiskCalculated", "NoRisk", "Youden")

#Option 2: Median

#Option 3: third quartile

## Second step: Univariate analysis to remove non-significant variables
characteristicsAll <- initialInfo[, initialIndex:length(initialInfo[1,])];
characteristicsWithoutClinic <- initialInfo[,initialIndex:(length(initialInfo[1,])-8)];
characteristicsOnlyClinic <- initialInfo[,(length(initialInfo[1,])-7):length(initialInfo[1,])];




