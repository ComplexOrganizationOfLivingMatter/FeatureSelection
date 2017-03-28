%Pipeline
genpath('src')
genpath('lib')

matrix2 = CharacteristicsGDDAAgainstControlRiskGDDUsingWeights13032017;
matrixChar = table2array(matrix2(:, 3:end));

class1 = cellfun(@(x) isequal('NoRisk', x), matrix2.Risk);
PCA_2_cc_Original(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk', 0);


