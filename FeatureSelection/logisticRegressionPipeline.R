#Based on the pipeline of Juan Francisco Martín-Rodríguez

#Import data
library(readxl)
initialInfo <- read_excel("D:/Pablo/Neuroblastoma/Results/graphletsCount/NuevosCasos/Analysis/NewClinicClassification_NewControls_11_01_2018.xlsx")

riskCalculatedLabels <- cut(initialInfo$RiskCalculated, breaks=c(-Inf, 0.5, 0.6, Inf), labels=c("low","middle","high"))
riskCalculatedLabels <- initialInfo$RiskCalculated;

initialIndex <- 41;

characteristicsAll <- initialInfo[, initialIndex:length(initialInfo[1,])];
characteristicsWithoutClinic <- initialInfo[,initialIndex:(length(initialInfo[1,])-8)];
characteristicsOnlyClinic <- initialInfo[,(length(initialInfo[1,])-7):length(initialInfo[1,])];

## First step: Dicotomize variables
#Option 1: Younden's Index
library(OptimalCutpoints)
cutoffValues = [];
for (numColumn in initialIndex:(length(initialInfo[1,])-8)) {
  youdenValue <- optimal.cutpoints(X = colnames(initialInfo[,numColumn]), status="RiskCalculated", tag.healthy="NoRisk", methods="Youden", data = as.data.frame(initialInfo))
  cutoffValues[numColumn] <- youdenValue$Youden$`Global`$optimal.cutoff$`cutoff`;
}

#Option 2: Median
mediansPerColumn <- apply(as.matrix(characteristicsWithoutClinic), 2, median) 
df %>% mutate(a = cut(a, breaks = quantile(a, probs = seq(0, 1, 0.2))))

#Option 3: third quartile
xs=quantile(actualVariable, c(0,1/3,2/3,1))
xs[1]=xs[1]-.00005
df1 <- df %>% mutate(category=cut(a, breaks=xs, labels=c(0, 1)))

## Second step: Univariate analysis to remove non-significant variables
