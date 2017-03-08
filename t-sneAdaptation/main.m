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























%Original
PCA_2_cc_Original(WT_120, CONT_120, 'WT_120', 'CONT_120');
PCA_2_cc_Original(WT_100, CONT_100, 'WT_100', 'CONT_100');

PCA_2_cc_Original(G93A_120, CONT_120, 'G93A_120', 'CONT_120');
PCA_2_cc_Original(G93A_100, CONT_100, 'G93A_100', 'CONT_100');

PCA_2_cc_Original(WT_100, G93A_100, 'WT_100', 'G93A_100');
PCA_2_cc_Original(WT_120, G93A_120, 'WT_120', 'G93A_120');

PCA_2_cc_Original(WT_100, WT_120, 'WT_100', 'WT_120');
PCA_2_cc_Original(CONT_100, CONT_120, 'CONT_100', 'CONT_120');
PCA_2_cc_Original(G93A_100, G93A_120, 'G93A_100', 'G93A_120');


%----- Perro ---------%

matrices = load('data/perro')
matrices=struct2cell(matrices);

names={'Health','GRMD','GRMD_MIB'};

parfor i=2:size(names,2)

    TSNEClassification(matrices{1},matrices{i},names{1},names{i})

end

%--- NB ---%
%uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\Characteristics_GDDA_AgainstControl_RiskWithWeights_24_02_2017.csv',1)
matrix2 = CharacteristicsGDDAAgainstControlInestability0sInsteadOf1s30012;
matrixChar = table2array(matrix2(:, 3:end));
matrixChar(matrixChar(:, :) == -1) = 0;
class2 = cellfun(@(x) isequal('Alta', x), matrix2.Inestability);
% class1 = cellfun(@(x) isequal('Media', x), matrix2.Inestabilidad);
% class3 = cellfun(@(x) isequal('Baja', x), matrix2.Inestabilidad);
% class4 = cellfun(@(x) isequal('Muy baja', x), matrix2.Inestabilidad);
%class1 = cellfun(@(x) isequal('NoHR', x), matrix2.Risk);
%PCA_2_cc_Original(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk');
PCA_2_cc_Original(matrixChar(class2 == 0, :), matrixChar(class2, :), 'Rest', 'Alta');