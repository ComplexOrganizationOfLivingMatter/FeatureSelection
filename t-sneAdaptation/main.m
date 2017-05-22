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

class1 = cellfun(@(x) isequal('Alta', x), matrix2.Inestabilidad);
PCA_2_cc_Original(matrixChar(class1==0, :), matrixChar(class1, :), 'Rest', 'High', 0);
class4 = cellfun(@(x) isequal('Muy baja', x), matrix2.Inestabilidad);
PCA_2_cc_Original(matrixChar(class4, :), matrixChar(class1, :), 'VeryLow', 'High', 0);
%PCA_2_cc_Original(matrixChar(class4, :), matrixChar(class2, :), 'VeryLow', 'High', 1);
class3 = cellfun(@(x) isequal('Baja', x), matrix2.Inestabilidad);
PCA_2_cc_Original(matrixChar(class4, :), matrixChar(class3, :), 'VeryLow', 'Low', 0);

%classifications(1, :) = {CharacteristicsGDDAAgainstControlInstabilityGDDUsingWeights1303, 'Alta', 'High', 'Rest'};
classifications(1, :) = {CharacteristicsGDDAAgainstControlRiskGDDUsingWeights13032017, 'NoRisk', 'NoRisk', 'HighRisk'};
classifications(2, :) = {CharacteristicsGDDAAgainstControlAge22032017, 'LowAge', 'LowAge', 'GreaterAge'};
classifications(3, :) = {CharacteristicsGDDAAgainstControlStage22032017, 'EarlyStage', 'EarlyStage', 'LateStage'};
classifications(4, :) = {CharacteristicsGDDAAgainstControlAP22032017, 'BetterAP', 'BetterAP', 'WorseAP'};
classifications(5, :) = {CharacteristicsGDDAAgainstControlNeupat22032017, 'BetterNeupat', 'BetterNeupat', 'WorseNeupat'};

clear classifications
classifications(1, :) = {CharacteristicsGDDAAgainstControlAP22032017, 'BetterAP', 'BetterAP', 'WorseAP'};
classifications(2, :) = {CharacteristicsGDDAAgainstControlNeupat22032017, 'BetterNeupat', 'BetterNeupat', 'WorseNeupat'};
parfor i = 1:size(classifications, 1)
    matrix2 = classifications{i, 1};
    matrixChar = table2array(matrix2(:, 3:end));
    class1 = cellfun(@(x) isequal(classifications{i, 2}, x), matrix2{:, 2});
    PCA_2_cc_Original(matrixChar(class1, :), matrixChar(class1==0, :), classifications{i, 3}, classifications{i, 4}, 0);
end

resResubCM(2, 2) / (resResubCM(2, 2) + resResubCM(1, 2)) * 100
resResubCM(1, 1) / (resResubCM(1, 1) + resResubCM(2, 1)) * 100
[resClass, score] = resubPredict(classificationInfo);
[X,Y,T,AUC] = perfcurve(classificationInfo.Y, score(:, 2), 'WorseAP');
AUC
Mejor_pca


%----- DNA-Damage -----%

characteristicsOfNetworks(:,{'meanMindistanceHeterochromatinPerFociDegree20','meanMindistanceHeterochromatinPerFociDegree21','meanMindistanceHeterochromatinPerFociDegree22','meanMindistanceHeterochromatinPerFociDegree23','meanMindistanceHeterochromatinPerFociDegree24','meanMindistanceHeterochromatinPerFociDegree25','meanMindistanceHeterochromatinPerFociDegree26','meanMindistanceHeterochromatinPerFociDegree27','meanMindistanceHeterochromatinPerFociDegree28'}) = [];
characteristicsOfNetworks(:,{'meandistanceHeterochromatinPerFociDegree6','meandistanceHeterochromatinPerFociDegree7','meandistanceHeterochromatinPerFociDegree8','meandistanceHeterochromatinPerFociDegree9','meandistanceHeterochromatinPerFociDegree10','meandistanceHeterochromatinPerFociDegree11','meandistanceHeterochromatinPerFociDegree12','meandistanceHeterochromatinPerFociDegree13','meandistanceHeterochromatinPerFociDegree14'}) = [];
matrix2 = characteristicsOfNetworks;
matrix2(:,'efficiency') = [];
matrixChar = table2array(matrix2(:, 4:end));
class1 = cellfun(@(x) isequal('IR_30min', x), matrix2.classOfCell);
PCA_2_cc_Original(matrixChar(class1==0, :), matrixChar(class1, :), 'VP16_30min', 'IR_30min', 0);