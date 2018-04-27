univariateAnalysis <-
  function(initialInfoDicotomized, initialIndex, dependentCategory) {
    require(rms)
    characteristicsAll <-
      initialInfoDicotomized[, initialIndex:length(initialInfoDicotomized[1, ])]
    
    characteristicsWithoutClinic <-
      initialInfoDicotomized[, initialIndex:(length(initialInfoDicotomized[1, ]) -
                                               8)]
    
    characteristicsOnlyClinic <-
      initialInfoDicotomized[, (length(initialInfoDicotomized[1, ]) - 7):length(initialInfoDicotomized[1, ])]
    
    
    characteristicsWithoutClinicVTN <-
      characteristicsWithoutClinic[, grepl("VTN" , colnames(characteristicsWithoutClinic))]
    
    univariateAnalysisPvalues <-
      lapply(colnames(characteristicsWithoutClinicVTN),
             
             function(var) {
               formula    <-
                 as.formula(paste(dependentCategory, " ~ `", var, '`', sep = ''))
               res.logist <-
                 glm(formula, data = initialInfoDicotomized, family = binomial(logit))
               anovaRes <-
                 anova(res.logist, test = 'Chisq')
               anovaRes$`Pr(>Chi)`[2]
             })
    
    univariateAnalysisPvalues[is.na(univariateAnalysisPvalues)] = 1
    
    
    significantCharacteristics <-
      characteristicsWithoutClinicVTN[, univariateAnalysisPvalues < pValueThreshold]
    
    return(significantCharacteristics);
  }