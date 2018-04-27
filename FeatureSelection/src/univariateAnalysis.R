univariateAnalysis <-
  function(initialInfoDicotomized,
           initialIndex,
           dependentCategory,
           characteristicsWithoutClinicVTN, 
           pValueThreshold) {
    require(rms)
    
    univariateAnalysisPvalues <-
      lapply(colnames(characteristicsWithoutClinicVTN),
             
             function(var) {
               formula    <-
                 as.formula(paste(dependentCategory, " ~ `", var, '`', sep = ''))
               res.logist <-
                 glm(formula, data = initialInfoDicotomized, family = binomial(logit))
               anovaRes <-
                 anova(res.logist, test =
                         'Chisq')
               anovaRes$`Pr(>Chi)`[2]
             })
    
    univariateAnalysisPvalues[is.na(univariateAnalysisPvalues)] = 1
    
    
    significantCharacteristics <-
      characteristicsWithoutClinicVTN[, univariateAnalysisPvalues < pValueThreshold]
    
    return(significantCharacteristics)
    
  }