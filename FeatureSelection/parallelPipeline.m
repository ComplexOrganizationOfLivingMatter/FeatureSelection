%Pipeline
addpath(genpath('src'))
addpath(genpath('lib'))

cd 'D:\Pablo\FeatureSelection\FeatureSelection\'

%classifications(1, :) = {CharacteristicsGDDAAgainstControlInstabilityGDDUsingWeights1303, 'Alta', 'High', 'Rest'};
classifications(1, :) = {CharacteristicsGDDAAgainstControlRiskGDDUsingWeights13032017, 'NoRisk', 'NoRisk', 'HighRisk', 'PCA'};
classifications(2, :) = {CharacteristicsGDDAAgainstControlRiskGDDUsingWeights13032017, 'NoRisk', 'NoRisk', 'HighRisk', 'DA'};
% classifications(2, :) = {CharacteristicsGDDAAgainstControlAge22032017, 'LowAge', 'LowAge', 'GreaterAge'};
% classifications(3, :) = {CharacteristicsGDDAAgainstControlStage22032017, 'EarlyStage', 'EarlyStage', 'LateStage'};
% classifications(4, :) = {CharacteristicsGDDAAgainstControlAP22032017, 'BetterAP', 'BetterAP', 'WorseAP'};
% classifications(5, :) = {CharacteristicsGDDAAgainstControlNeupat22032017, 'BetterNeupat', 'BetterNeupat', 'WorseNeupat'};

parfor i = 1:size(classifications, 1)
    matrix2 = classifications{i, 1};
    matrixChar = table2array(matrix2(:, 3:end));
    class1 = cellfun(@(x) isequal(classifications{i, 2}, x), matrix2{:, 2});
    FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1==0, :), classifications{i, 3}, classifications{i, 4}, classifications{i, 5});
end