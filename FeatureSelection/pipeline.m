%Pipeline
addpath(genpath('src'))
addpath(genpath('lib'))

cd 'D:\Pablo\FeatureSelection\PCAFeatureSelection\'

matrix2 = CharacteristicsGDDAAgainstControlRiskGDDUsingWeights13032017;
matrixChar = table2array(matrix2(:, 3:end));

class1 = cellfun(@(x) isequal('NoRisk', x), matrix2.Risk);
FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk');