logisticFeatureSelection <- function(significantAndClinicChars, initialInfoDicotomized, dependentCategory, binomial, usedMethod) {
  if (usedMethod == "method1")
  require(leaps)
  library(bestglm)
  lbw.for.best.logistic <-
    cbind(significantAndClinicChars, initialInfoDicotomized[1:nrow(initialInfoDicotomized), dependentCategory])
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
  
  bestCharacteristics_Method1 = res.best.logistic$BestModel$model[1:nrow(res.best.logistic$BestModel$model), 2:ncol(res.best.logistic$BestModel$model)];
  
  logisticFeatureSelection <- function(glmulti, significantAndClinicChars, dependentCategory, initialInfoDicotomized, binomial) {
    library(glmulti)
    significantAndClinicCharsWithoutColNames <- significantAndClinicChars;
    xnam <- paste0("x", 1:length(significantAndClinicChars))
    
    colnames(significantAndClinicCharsWithoutColNames) <- xnam
    newFormulaWithoutNames <- as.formula(paste(dependentCategory, "~", paste(xnam, collapse= "+")))
    
    # Weird variables were not allowed, so we need to transform them into variables without spaces.
    # We decided to transform them into x and the number of column (x1, x2, ...)
    glmulti.logistic.out <-
      glmulti(newFormulaWithoutNames, data = as.data.frame(cbind(significantAndClinicCharsWithoutColNames, initialInfoDicotomized[1:nrow(initialInfoDicotomized), dependentCategory])),
              level = 1,               # No interaction considered
              method = "h",            # Exhaustive approach
              crit = "aic",            # AIC as criteria
              confsetsize = 5,         # Keep 5 best models
              plotty = F, report = F,  # No plot or interim reports
              fitfunction = "glm",     # glm function
              family = binomial)
  }
  
  
  #Best model
  glmulti.logistic.out@objects[[1]]
  #5 best models
  glmulti.logistic.out@formulas
}