%Pipeline
addpath(genpath('src'))
addpath(genpath('lib'))

cd 'D:\Pablo\FeatureSelection\FeatureSelection\'

matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
matrixChar = table2array(matrix2(:, 8:end));
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);

class1 = cellfun(@(x) isequal('Alta', x), matrix2.Inestabilidad);
class4 = cellfun(@(x) isequal('Muy baja', x), matrix2.Inestabilidad);
class3 = cellfun(@(x) isequal('Baja', x), matrix2.Inestabilidad);

methods = {'DA'; 'PCA'};
parfor i = 1:size(methods, 1)
    FeatureSelection_2_cc(matrixChar(class1==0 & emptyCells, :), matrixChar(class1, :), 'Rest', 'High', methods{i});
    FeatureSelection_2_cc(matrixChar(class4, :), matrixChar(class1, :), 'VeryLow', 'High', methods{i});
    FeatureSelection_2_cc(matrixChar(class4, :), matrixChar(class3, :), 'VeryLow', 'Low', methods{i});
end

classifications(1, :) = { 'NoRisk', 'NoRisk', 'HighRisk', 'DA'};
classifications(2, :) = { 'LowAge', 'LowAge', 'GreaterAge', 'DA'};
classifications(3, :) = { 'EarlyStage', 'EarlyStage', 'LateStage', 'DA'};
classifications(4, :) = { 'BetterAP', 'BetterAP', 'WorseAP', 'DA'};
classifications(5, :) = { 'BetterNeupat', 'BetterNeupat', 'WorseNeupat', 'DA'};
classifications(6, :) = { 'NoRisk', 'NoRisk', 'HighRisk', 'PCA'};
classifications(7, :) = { 'LowAge', 'LowAge', 'GreaterAge', 'PCA'};
classifications(8, :) = {'EarlyStage', 'EarlyStage', 'LateStage', 'PCA'};
classifications(9, :) = {'BetterAP', 'BetterAP', 'WorseAP', 'PCA'};
classifications(10, :) = {'BetterNeupat', 'BetterNeupat', 'WorseNeupat', 'PCA'};

matrixChar = table2array(matrix2(:, 8:end));
parfor i = 1:size(classifications, 1)
    emptyCells = cellfun(@(x) isequal('', x), matrix2{:, i+2});
    class1 = cellfun(@(x) isequal(classifications{i, 1}, x), matrix2{:, i+2});
    FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1==0 & ~emptyCells, :), classifications{i, 2}, classifications{i, 3}, classifications{i, 4});
end

%% Only VTN characteristics
variableNames = strfind(lower(CharacteristicsGDDAAgainstControlToClassify24042017.Properties.VariableNames), 'vtn');
headerNamesWithVTN = cellfun(@(x) isempty(x) == 0, variableNames);
headerNamesWithVTN(:, 1:7) = [];
matrixChar = table2array(matrix2(:, 8:end));
parfor i = 1:size(classifications, 1)
    emptyCells = cellfun(@(x) isequal('', x), matrix2{:, i+2});
    class1 = cellfun(@(x) isequal(classifications{i, 1}, x), matrix2{:, i+2});
    FeatureSelection_2_cc(matrixChar(class1, headerNamesWithVTN), matrixChar(class1==0 & ~emptyCells, headerNamesWithVTN), classifications{i, 2}, classifications{i, 3}, classifications{i, 4});
end
