%Pipeline

cd 'D:\Pablo\FeatureSelection\FeatureSelection\'
addpath(genpath('src'))
addpath(genpath('lib'))
% 
% 
% 
% % matrix2 = CharacteristicsGDDAAgainstControlToClassify24042017;
% % emptyCells = cellfun(@(x) isequal('', x), matrix2.Risk);
% % matrix2 = matrix2(emptyCells == 0, :);
% % matrixChar = table2array(matrix2(:, 8:end));
% % class1 = cellfun(@(x) isequal('NoRisk', x), matrix2.Risk);
% % %characteriticsOrg = [1 2 4 6 7 8 11 12 13 14 16 18 20 21 23 25 26]';
% % %FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk', 'DA');
% % %FeatureSelection_2_cc(matrixChar(class1, :), matrixChar(class1 == 0, :), 'NoRisk', 'HighRisk', 'LogisticRegression');
% % 
% % FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'LogisticRegression');
% % FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'LogisticRegression');
% % FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'LogisticRegression');
% % %FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'DA');
% % %FeatureSelection_2_cc(matrixChar, matrix2.Inestabilidad, 'DA');
% % %FeatureSelection_2_cc(matrixChar, matrix2.Risk, 'PCA');
% % %FeatureSelection_2_cc(matrixChar, matrix2.Inestabilidad, 'PCA');
% % 
% % 
% % 
% % % %% ----------- Logistic regression ----------- %%
% % % [b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(matrixChar, class1, 'scale', 'on');
% % % selectedChar = [15 19 47 14 18 17 26];
% % % %selectedChar = inmodel;
% % % [b,dev,stats] = glmfit(matrixChar(:, selectedChar), class1,'binomial','logit'); % Logistic regression
% % % x = matrixChar(:, selectedChar);
% % % n = ones(size(class1, 2),1);
% % % y = class1'==0;
% % % yfit = glmval(b, matrixChar(:, selectedChar), 'logit')';
% % % [resResubCM, ~] = confusionmat(class1, (yfit > 0.5)); %0.35 works better
% % % sensitivity = resResubCM(2, 2) / sum(resResubCM(2, :)) * 100;
% % % specifity = resResubCM(1, 1) / sum(resResubCM(1, :)) * 100;
% % 
% % 
% % % %% --- Shrinkage methods ---%
% % % %The lasso
% % % %We should see where are 7 degrees of freedom and get that column
% % % [B,FitInfo] = lasso(matrixChar, class1, 'CV', 5);
% % % ax = lassoPlot(B,FitInfo, 'CV', 5)
% % % find(B(:, FitInfo.DF == 7))
% % % %Ridge
% % % B = ridge(class1, matrixChar, 7, 1);
% % % [a, i] = sort(abs(B), 'descend');
% % % i(1:7)
% % % 
% % % 
% % % %% ---------------- DNA DAMAGE ---------------------- %%
% % % matrix2 = characteristicsOfNetworks;
% % % matrix2(:,'efficiency') = [];
% % % matrixChar = table2array(matrix2(:, 4:end));
% % % class1 = cellfun(@(x) isequal('IR_30min', x), matrix2.classOfCell);
% % % FeatureSelection_2_cc(matrixChar(class1==0, :), matrixChar(class1, :), 'VP16_30min', 'IR_30min', 'PCA');
% % % FeatureSelection_2_cc(matrixChar(class1==0, :), matrixChar(class1, :), 'VP16_30min', 'IR_30min', 'DA');
% % % 
% % % %% --- New ---%
% % % [beta,Sigma,E,CovB,logL] = mvregress(matrixChar, class1);
% % % b = stepwiselm(matrixChar, class1,'Criterion','adjrsquared');
% 
% %% Logistic regression
%uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\NewClinicClassification_NewControls_02_01_2018.xlsx',1);
matrixInit = NewClinicClassificationNewControls02012018;
initialIndex = 50;
columnNames = matrixInit.Properties.VariableNames(initialIndex:end);
%RiskREAL
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskReal;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcRiskReal = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
ftcRiskReal.ccsSelected = columnNames(ftcRiskReal.indicesCcsSelected);

%RiskCalculated
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskCalculated);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskCalculated;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));

ftcRiskCalculated = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
ftcRiskCalculated.ccsSelected = columnNames(ftcRiskCalculated.indicesCcsSelected);

%High Instability vs Rest
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Rest'};
ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
ftcInstability = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
ftcInstability.ccsSelected = columnNames(ftcInstability.indicesCcsSelected);
% % 
% % 
% % %High Instability vs Very Low
% % emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
% % matrix2 = matrixInit(emptyCells == 0, :);
% % matrixChar = table2array(matrix2(:, initialIndex:end));
% % labelsUsed = matrix2.Instability;
% % ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
% % ftc.expansion = [1 1 1 1];
% % ftcInstabilityHighVsVeryLow = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'High') | isequal(x, 'VeryLow'), labelsUsed));
% % ftcInstabilityHighVsVeryLow.ccsSelected = columnNames(ftcInstabilityHighVsVeryLow.indicesCcsSelected);
% % 
% % 
% % %Low Instability vs Very Low
% % emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
% % matrix2 = matrixInit(emptyCells == 0, :);
% % matrixChar = table2array(matrix2(:, initialIndex:end));
% % labelsUsed = matrix2.Instability;
% % ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', 1:size(matrixChar, 2));
% % ftc.expansion = [1 1 1 1];
% % ftcInstabilityLowVsVeryLow = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'Low') | isequal(x, 'VeryLow'), labelsUsed));
% % ftcInstabilityLowVsVeryLow.ccsSelected = columnNames(ftcInstabilityLowVsVeryLow.indicesCcsSelected);
% % 
% % % ftc = ftcRiskCalculated;
% % % %filter = cellfun(@(x) isequal(x, 'Low') | isequal(x, 'VeryLow'), ftc.labels);
% % % filter = 1:size(ftc.matrixAllCases, 1);
% % % noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), ftc.labels);
% % % %noRiskLabels = cellfun(@(x) isequal(x, 'Low'), ftc.labels(filter));
% % % getHowGoodAreTheseCharacteristics(ftc.matrixAllCases(filter, ftc.indicesCcsSelected), noRiskLabels + 1, ones(size(matrixChar(filter, :), 1), 1), 'LogisticRegression');
% % % 
% % % indices = [3
% % %      4
% % %      5
% % %     48
% % %     65
% % %     83
% % %     84
% % %     86];
% % % 
% % % failingCases = matrix2(indices, :);
% %% ONLY VTN
% 
% vtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')) == 0, columnNames));
% %RiskReal
% emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.RiskReal;
% noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
% labelsUsed(noRiskLabels == 0) = {'HighRisk'};
% ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', vtnChar);
% warning('off', 'all')
% ftcRiskRealVTN = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
% ftcRiskRealVTN.ccsSelected = columnNames(ftcRiskRealVTN.indicesCcsSelected);
% 
% %RiskCalculated
% emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskCalculated);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.RiskCalculated;
% noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
% labelsUsed(noRiskLabels == 0) = {'HighRisk'};
% ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', vtnChar);
% ftcRiskCalculatedVTN = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
% ftcRiskCalculatedVTN.ccsSelected = columnNames(ftcRiskCalculatedVTN.indicesCcsSelected);
% 
% %High Instability vs Rest
% emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.Instability;
% noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
% labelsUsed(noRiskLabels == 0) = {'Rest'};
% ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', vtnChar);
% ftc.expansion = [1 1 1 1];
% ftcInstabilityVTN = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
% ftcInstabilityVTN.ccsSelected = columnNames(ftcInstabilityVTN.indicesCcsSelected);
% % 
% % %High Instability vs Very Low
% % emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
% % matrix2 = matrixInit(emptyCells == 0, :);
% % matrixChar = table2array(matrix2(:, initialIndex:end));
% % labelsUsed = matrix2.Instability;
% % ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', vtnChar);
% % ftc.expansion = [1 1 1 1];
% % ftcInstabilityHighVsVeryLowVTN = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'High') | isequal(x, 'VeryLow'), labelsUsed));
% % ftcInstabilityHighVsVeryLowVTN.ccsSelected = columnNames(ftcInstabilityHighVsVeryLowVTN.indicesCcsSelected);
% % 
% % %Low Instability vs Very Low
% % emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
% % matrix2 = matrixInit(emptyCells == 0, :);
% % matrixChar = table2array(matrix2(:, initialIndex:end));
% % labelsUsed = matrix2.Instability;
% % ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', vtnChar);
% % ftcInstabilityLowVsVeryLowVTN = ftc.executeFeatureSelection(cellfun(@(x) isequal(x, 'Low') | isequal(x, 'VeryLow'), labelsUsed));
% % ftcInstabilityLowVsVeryLowVTN.ccsSelected = columnNames(ftcInstabilityLowVsVeryLowVTN.indicesCcsSelected);
% 

% ftc = ftcInstability;
% res = [];
% %filter = cellfun(@(x) isequal(x, 'Low') | isequal(x, 'VeryLow'), ftc.labels);
% emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
% matrix2 = matrixInit(emptyCells == 0, :);
% labelsUsed = matrix2.Instability;
% matrixChar = table2array(matrix2(:, initialIndex:end));
% noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
% filter = 1:size(ftc.matrixAllCases, 1);
% vtnChar = 1:size(columnNames, 2);
% for idChar = vtnChar
%     [ goodness, ~, sensitivity, specificity] = getHowGoodAreTheseCharacteristics(ftc.matrixAllCases(filter, idChar), noRiskLabels + 1, ones(size(matrixChar(filter, :), 1), 1), 'LogisticRegression');
%     [h,p,ci,stats] = ttest2(matrixChar(noRiskLabels == 0, idChar), matrixChar(noRiskLabels, idChar));
%     res(idChar, :) = [ goodness, sensitivity, specificity, h, p];
% end
% [res, indices] = sortrows(res, -1);
% indicesNames = columnNames(indices);
% 
% mean(res(res(:, 4) == 1, 1))
% mean(res(res(:, 4) == 0, 1))

%% Calculate mean info
% means = [];
% ftc = ftcRiskRealVTN;
% emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
% matrix2 = matrixInit(emptyCells == 0, :);
% labelsUsed = matrix2.RiskReal;
% matrixChar = table2array(matrix2(:, initialIndex:end));
% noRiskLabels = cellfun(@(x) isequal(x, 'HighRisk'), labelsUsed);
% means(:, 1) = ftc.indicesCcsSelected;
% means(:, 2) = mean(matrixChar(noRiskLabels, ftc.indicesCcsSelected))';
% means(:, 3) = std(matrixChar(noRiskLabels, ftc.indicesCcsSelected))';
% means(:, 4) = mean(matrixChar(noRiskLabels == 0, ftc.indicesCcsSelected))';
% means(:, 5) = std(matrixChar(noRiskLabels == 0, ftc.indicesCcsSelected))';
% [h,p,ci,stats] = ttest2(matrixChar(noRiskLabels == 0, ftc.indicesCcsSelected), matrixChar(noRiskLabels, ftc.indicesCcsSelected));
% means(:, 6) = p';

warning('on', 'all')