%Pipeline

cd 'D:\Pablo\FeatureSelection\FeatureSelection\'
addpath(genpath('src'))
addpath(genpath('lib'))



matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Risk);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
class1 = cellfun(@(x) isequal('NoRisk', x), matrix2.Risk);
%characteriticsOrg = [1 2 4 6 7 8 11 12 13 14 16 18 20 21 23 25 26]';
%FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk', 'DA');
%FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk', 'LogisticRegression');

FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'LogisticRegression');
FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'LogisticRegression');
FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'LogisticRegression');
%FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'DA');
%FeatureSelection_2_cc(matrixChar, matrix2.Inestabilidad, 'DA');
%FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'PCA');
%FeatureSelection_2_cc(matrixChar, matrix2.Inestabilidad, 'PCA');



% %% ----------- Logistic regression ----------- %%
% [b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(matrixChar, class1, 'scale', 'on');
% selectedChar = [15 19 47 14 18 17 26];
% %selectedChar = inmodel;
% [b,dev,stats] = glmfit(matrixChar(:, selectedChar), class1,'binomial','logit'); % Logistic regression
% x = matrixChar(:, selectedChar);
% n = ones(size(class1, 2),1);
% y = class1'==0;
% yfit = glmval(b, matrixChar(:, selectedChar), 'logit')';
% [resResubCM, ~] = confusionmat(class1, (yfit > 0.5)); %0.35 works better
% sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
% specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;


% %% --- Shrinkage methods ---%
% %The lasso
% %We should see where are 7 degrees of freedom and get that column
% [B,FitInfo] = lasso(matrixChar, class1, 'CV', 5);
% ax = lassoPlot(B,FitInfo, 'CV', 5)
% find(B(:, FitInfo.DF == 7))
% %Ridge
% B = ridge(class1, matrixChar, 7, 1);
% [a, i] = sort(abs(B), 'descend');
% i(1:7)
% 
% 
% %% ---------------- DNA DAMAGE ---------------------- %%
% matrix2 = characteristicsOfNetworks;
% matrix2(:,'efficiency') = [];
% matrixChar = table2array(matrix2(:, 4:end));
% class1 = cellfun(@(x) isequal('IR_30min', x), matrix2.classOfCell);
% FeatureSelection_2_cc(matrixChar(class1==0, :), matrixChar(class1, :), 'VP16_30min', 'IR_30min', 'PCA');
% FeatureSelection_2_cc(matrixChar(class1==0, :), matrixChar(class1, :), 'VP16_30min', 'IR_30min', 'DA');
% 
% %% --- New ---%
% [beta,Sigma,E,CovB,logL] = mvregress(matrixChar, class1);
% b = stepwiselm(matrixChar, class1,'Criterion','adjrsquared');

%% Logistic regression

%Risk
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Risk);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Risk;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcRisk = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%High Instability vs Rest
matrix2 = CharacteristicsGDDAAgainstControlToClassify29062017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Inestabilidad;
noRiskLabels = cellfun(@(x) isequal(x, 'Alta'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Rest'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcInstability = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%High Instability vs Very Low
matrix2 = CharacteristicsGDDAAgainstControlToClassify29062017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Inestabilidad;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftc.expansion = [1 1 1 1];
ftcInstabilityHighVsVeryLow = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'Alta') | isequal(x, 'Muy baja'), labelsUsed));

%Low Instability vs Very Low
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Inestabilidad;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcInstabilityLowVsVeryLow = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'Baja') | isequal(x, 'Muy baja'), labelsUsed));

%Age
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Age);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Age;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcAge = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%AP
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.AP);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.AP;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcAP = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%Stage
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Stage);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Stage;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcStage = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%Neupat
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Neupat);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Neupat;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcNeupat = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%% ONLY VTN
%Risk
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Risk);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Risk;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcRisk = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%High Instability vs Rest
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Inestabilidad;
noRiskLabels = cellfun(@(x) isequal(x, 'Alta'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Rest'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcInstability = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%High Instability vs Very Low
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Inestabilidad;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcInstability = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'Alta') | isequal(x, 'Muy baja'), labelsUsed));

%Low Instability vs Very Low
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Inestabilidad);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Inestabilidad;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcInstability = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'Baja') | isequal(x, 'Muy baja'), labelsUsed));

%Age
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Age);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Age;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcAge = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%AP
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.AP);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.AP;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcAP = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%Stage
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Stage);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Stage;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcStage = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');

%Neupat
matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
emptyCells = cellfun(@(x) isequal('', x), matrix2.Neupat);
matrix2 = matrix2(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, 8:end));
labelsUsed = matrix2.Neupat;
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 29:50);
ftcStage = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');