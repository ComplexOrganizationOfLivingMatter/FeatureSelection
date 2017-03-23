load('data/Matrices_cc')

TSNEClassification(WT_120, CONT_120, 'WT_120', 'CONT_120');
TSNEClassification(CONT_120, WT_120, 'CONT_120', 'WT_120');

TSNEClassification(WT_100, CONT_100, 'WT_100', 'CONT_100');
TSNEClassification(CONT_100, WT_100, 'CONT_100', 'WT_100');

TSNEClassification(CONT_120, G93A_120, 'CONT_120', 'G93A_120');
TSNEClassification(G93A_120, CONT_120, 'G93A_120', 'CONT_120');

TSNEClassification(G93A_100, CONT_100, 'G93A_100', 'CONT_100');
TSNEClassification(CONT_100, G93A_100, 'CONT_100', 'G93A_100');

TSNEClassification(WT_100, G93A_100, 'WT_100', 'G93A_100');
TSNEClassification(WT_120, G93A_120, 'WT_120', 'G93A_120');

TSNEClassification(WT_100, WT_120, 'WT_100', 'WT_120');
TSNEClassification(CONT_100, CONT_120, 'CONT_100', 'CONT_120');
TSNEClassification(G93A_100, G93A_120, 'G93A_100', 'G93A_120');



%% Original
PCA_2_cc_Original(WT_120, CONT_120, 'WT_120', 'CONT_120');
PCA_2_cc_Original(WT_100, CONT_100, 'WT_100', 'CONT_100');

PCA_2_cc_Original(G93A_120, CONT_120, 'G93A_120', 'CONT_120');
PCA_2_cc_Original(G93A_100, CONT_100, 'G93A_100', 'CONT_100');

PCA_2_cc_Original(WT_100, G93A_100, 'WT_100', 'G93A_100');
PCA_2_cc_Original(WT_120, G93A_120, 'WT_120', 'G93A_120');

PCA_2_cc_Original(WT_100, WT_120, 'WT_100', 'WT_120');
PCA_2_cc_Original(CONT_100, CONT_120, 'CONT_100', 'CONT_120');
PCA_2_cc_Original(G93A_100, G93A_120, 'G93A_100', 'G93A_120');


%% ----- Perro ---------%

matrices = load('data/perro')
matrices=struct2cell(matrices);

names={'Health','GRMD','GRMD_MIB'};

parfor i=2:size(names,2)

    TSNEClassification(matrices{1},matrices{i},names{1},names{i})

end

%% --- NB ---%
%uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\Characteristics_GDDA_AgainstControl_RiskWithWeights_24_02_2017.csv',1)
%---------- INSTABILITY ---------------%
matrix2 = CharacteristicsGDDAAgainstControlInstabilityGDDUsingWeights1303;
matrixChar = table2array(matrix2(:, 3:end));
matrixChar(matrixChar(:, :) == -1) = 0;

class1 = cellfun(@(x) isequal('Alta', x), matrix2.Inestabilidad);
class4 = cellfun(@(x) isequal('Muy baja', x), matrix2.Inestabilidad);
PCA_2_cc_Original(matrixChar(class4, :), matrixChar(class1, :), 'VeryLow', 'High', 0);
%PCA_2_cc_Original(matrixChar(class4, :), matrixChar(class2, :), 'VeryLow', 'High', 1);
class3 = cellfun(@(x) isequal('Baja', x), matrix2.Inestabilidad);
PCA_2_cc_Original(matrixChar(class4, :), matrixChar(class3, :), 'VeryLow', 'Low', 0);

classifications(1, :) = {CharacteristicsGDDAAgainstControlInstabilityGDDUsingWeights1303, 'Alta', 'Rest', 'High'};
classifications(2, :) = {CharacteristicsGDDAAgainstControlRiskGDDUsingWeights13032017, 'NoRisk', 'NoRisk', 'HighRisk'};
classifications(3, :) = {CharacteristicsGDDAAgainstControlAge22032017, 'LowAge', 'LowAge', 'GreaterAge'};
classifications(4, :) = {CharacteristicsGDDAAgainstControlStage22032017, 'EarlyStage', 'EarlyStage', 'LateStage'};
classifications(5, :) = {CharacteristicsGDDAAgainstControlAP22032017, 'BetterAP', 'BetterAP', 'WorseAP'};
classifications(6, :) = {CharacteristicsGDDAAgainstControlNeupat22032017, 'BetterNeupat', 'BetterNeupat', 'WorseNeupat'};

parfor i = 1:size(classifications, 2)
    matrix2 = classifications{i, 1};
    matrixChar = table2array(matrix2(:, 3:end));
    matrixChar(matrixChar(:, :) == -1) = 0;
    class1 = cellfun(@(x) isequal(classifications{i, 2}, x), matrix2{:, 2});
    PCA_2_cc_Original(matrixChar(class1, :), matrixChar(class1==0, :), classifications{i, 3}, classifications{i, 4}, 0);
end