dicotomizeVariables <- function(initialInfo, initialIndex, columnStatus, healthyTag, cutoffMethod) {
  
  
  initialInfoDicotomized <- initialInfo
  
  ## Option 1: Younden's Index
  library(OptimalCutpoints)
  cutoffValues = c();
  for (numColumn in initialIndex:(length(initialInfo[1,])-8)) {
    #You have several methods to use instead of Youden
    youdenValue <- optimal.cutpoints(X = colnames(initialInfo[,numColumn]), status=columnStatus, tag.healthy=healthyTag, methods=cutoffMethod, data = as.data.frame(initialInfo))
    cutoffValues[numColumn] <- youdenValue$Youden$`Global`$optimal.cutoff$`cutoff`
    
    #Perform the cutoff
    initialInfoDicotomized[,numColumn] <- as.numeric(initialInfo[,numColumn] > cutoffValues[numColumn]);
  }
  
  
  # ## Option 2: Median
  # mediansPerColumn <- apply(as.matrix(characteristicsWithoutClinic), 2, median) 
  # df %>% mutate(a = cut(a, breaks = quantile(a, probs = seq(0, 1, 0.2))))
  # 
  # ## Option 3: third quartile
  # xs=quantile(actualVariable, c(0,1/3,2/3,1))
  # xs[1]=xs[1]-.00005
  # df1 <- df %>% mutate(category=cut(a, breaks=xs, labels=c(0, 1)))
  
  return (initialInfoDicotomized)
}