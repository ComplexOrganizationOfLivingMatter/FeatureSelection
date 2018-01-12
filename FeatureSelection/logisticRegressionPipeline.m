%% Logistic regression
%uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\NewClinicClassification_NewControls_11_01_2018.xlsx',1);
matrixInit = NewClinicClassificationNewControls11012018;
initialIndex = 50;
columnNames = matrixInit.Properties.VariableNames(initialIndex:end);
% Not VTN
notVtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')), columnNames));

% ONLY VTN
vtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')) == 0, columnNames));

% TOPOLOGICAL FEATURES
topologicalFeatures = [1 2 3 5 7 10 11 12 13 15 16 17 18 20 22 25 26 27 28 30 31 32 33 35 37 40 41 42 43 45 46 47 48 50 52 55 56 57 58 60 61 62 63 65 67 70 71 72 73 75 77 78 79 80 82 84 87 88 89 90 92 93 94 95 97 99 102 103 104 105 107];
nonTopologicalFeatures = setdiff(1:length(columnNames), topologicalFeatures);

%% RiskREAL
warning('off', 'all')
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskReal;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};

% All the executions
[ ftcRiskRealOnlyTopFeatures ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', 1:size(matrixChar, 2) );
[ ftcRiskRealVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnChar );
[ ftcRiskRealNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', notVtnChar );
[ ftcRiskRealTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', topologicalFeatures );
[ ftcRiskRealNonTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', nonTopologicalFeatures );

%% High Instability vs Rest
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Rest'};

[ ftcInstabilityOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', 1:size(matrixChar, 2) );
[ ftcInstabilityVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnChar );
[ ftcInstabilityNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', notVtnChar );
[ ftcInstabilityTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', topologicalFeatures );
[ ftInstabilityNonTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', nonTopologicalFeatures );


save(strcat('newNBResultsWithTopFeatures_', date), 'ftcRiskRealOnlyTopFeatures', 'ftcRiskRealVTNOnlyTopFeatures', 'ftcRiskRealNotVTNOnlyTopFeatures', 'ftcInstabilityOnlyTopFeatures', 'ftcInstabilityVTNOnlyTopFeatures', 'ftcInstabilityNotVTNOnlyTopFeatures', 'ftcRiskRealTopologicalOnlyTopFeatures', 'ftcRiskRealNonTopologicalOnlyTopFeatures', 'ftcInstabilityTopologicalOnlyTopFeatures', 'ftcInstabilityNonTopologicalOnlyTopFeatures');

warning('on', 'all')