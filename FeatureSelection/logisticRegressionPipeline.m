%% Logistic regression
% %uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\NewClinicClassification_NewControls_02_01_2018.xlsx',1);
matrixInit = NewClinicClassificationNewControls02012018;
initialIndex = 50;
columnNames = matrixInit.Properties.VariableNames(initialIndex:end);
% Not VTN
noVtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')), columnNames));

% ONLY VTN
vtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')) == 0, columnNames));

%% RiskREAL
warning('off', 'all')
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskReal;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};

% All the executions
[ ftcRiskRealOnlyTopFeatures ] = getFTCWithTopFeatures( ftc, labelsUsed, matrixChar, columnNames, 'HighRisk', 1:size(matrixChar, 2) );
[ ftcRiskRealVTNOnlyTopFeatures ] = getFTCWithTopFeatures( ftc, labelsUsed, matrixChar, columnNames, 'HighRisk', vtnChar );
[ ftcRiskRealNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures( ftc, labelsUsed, matrixChar, columnNames, 'HighRisk', notVtnChar );

%% High Instability vs Rest
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Rest'};

[ ftcInstabilityOnlyTopFeatures ] = getFTCWithTopFeatures( ftc, labelsUsed, matrixChar, columnNames, 'High', 1:size(matrixChar, 2) );
[ ftcInstabilityVTNOnlyTopFeatures ] = getFTCWithTopFeatures( ftc, labelsUsed, matrixChar, columnNames, 'High', vtnChar );
[ ftcInstabilityNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures( ftc, labelsUsed, matrixChar, columnNames, 'High', notVtnChar );

save(strcat('newNBResultsWithTopFeatures_', date), 'ftcRiskRealOnlyTopFeatures', 'ftcRiskRealVTNOnlyTopFeatures', 'ftcRiskRealNotVTNOnlyTopFeatures', 'ftcInstabilityOnlyTopFeatures', 'ftcInstabilityVTNOnlyTopFeatures', 'ftcInstabilityNotVTNOnlyTopFeatures');

warning('on', 'all')