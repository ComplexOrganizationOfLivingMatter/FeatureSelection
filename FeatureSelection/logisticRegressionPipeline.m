
cd 'D:\Pablo\FeatureSelection\FeatureSelection\'
addpath(genpath('src'))
addpath(genpath('lib'))

%% Logistic regression
%uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\NewClinicClassification_NewControls_11_01_2018.xlsx',1);
matrixInit = NewClinicClassificationNewControls11012018;
%matrixInit.VTNHSCORE = [];
initialIndex = 41;
%realCharVTNNames = {'Extracellular - Sorting';'Extracellular - Iteration';'Extracellular - MST';'Extracellular - meanPercentageOfFibrePerCell';'Extracellular - stdPercentageOfFibrePerCell';'Extracellular - meanPercentageOfFibrePerFilledCell';'Extracellular - stdPercentageOfFibrePerFilledCell';'Extracellular - meanQuantityOfBranchesPerCell';'Extracellular - meanQuantityOfBranchesFilledPerCell';'Extracellular - eulerNumberPerObject';'Extracellular - eulerNumberPerCell';'Extracellular - eulerNumberPerFilledCell';'Extracellular - numberOfHolesPerObject';'Extracellular - meanAreaOfHoles';'Extracellular - stdAreaOfHoles';'Peri/intracellular - Sorting';'Peri/intracellular - Iteration';'Peri/intracellular - MST';'Peri/intracellular - meanPercentageOfFibrePerCell';'Peri/intracellular - stdPercentageOfFibrePerCell';'Peri/intracellular - meanPercentageOfFibrePerFilledCell';'Peri/intracellular - stdPercentageOfFibrePerFilledCell';'Peri/intracellular - meanQuantityOfBranchesPerCell';'Peri/intracellular - meanQuantityOfBranchesFilledPerCell';'Peri/intracellular - eulerNumberPerObject';'Peri/intracellular - eulerNumberPerCell';'Peri/intracellular - eulerNumberPerFilledCell';'Peri/intracellular - numberOfHolesPerObject';'Peri/intracellular - meanAreaOfHoles';'Peri/intracellular - stdAreaOfHoles';'meanDiff_Intense_Moderate';'stdDiff_Intense_Moderate';'Percentage of stained area negative cells';'Objs/mm2 negative cells';'Extracellular - Percantege of stained area';'Extracellular - Objs/mm2';'Peri/intracellular - Percentage of stained area';'Peri/intracellular - Objs/mm2';'Total cells';'Percentage of negative cells';'Peri/intracellular - Percentage Of Positive cells';'Ratio of Negative pixels to total pixels';'Extracellular - Ratio of Weak-Positive pixels to total pixels';'Extracellular - Ratio of Moderate-Positive pixels to total pixels';'Peri/intracellular - Ratio of Strong-Positive pixels to total pixels';'Ratio of all positive pixels';'H-SCORE'};
columnNames = matrixInit.Properties.VariableNames(initialIndex:end);
% Not VTN
notVtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')), columnNames));

% ONLY VTN
vtnChar = find(cellfun(@(x) isempty(strfind(lower(x), 'vtn')) == 0, columnNames));

% ONLY VTN+
vtnWeakModerateChar = [46:60 110 111 118 119];

% ONLY VTN++
vtnIntenseChar = find(cellfun(@(x) ~isempty(strfind(lower(x), 'vtn')) & (~isempty(strfind(lower(x), 'intrac')) | ~isempty(strfind(lower(x), '1')) | ~isempty(strfind(lower(x), 'strong'))), columnNames));

% TOPOLOGICAL FEATURES
topologicalFeatures = [1 2 3 5 7 10 11 12 13 15 16 17 18 20 22 25 26 27 28 30 31 32 33 35 37 40 41 42 43 45 46 47 48 50 52 55 56 57 58 60 61 62 63 65 67 70 71 72 73 75 77 78 79 80 82 84 87 88 89 90 92 93 94 95 97 99 102 103 104 105 107];
nonTopologicalFeatures = setdiff(1:length(columnNames), topologicalFeatures);

homogeneityIndex = [1 2 3 16 17 18 31 32 33 46 47 48 61 62 63 78 79 80 93 94 95]; 

homogeneityIndexVTN = [46 47 48 61 62 63];

%SelectedFeatures
bestCombinationAllRiskReal = [109,7,143,131,34,66,68];
bestCombinationAllRiskCalculado = [149,109,151,66,72,32,130];
bestCombinationAllInstability = [59, 69, 136];
%All wihtout VTN
bestCombinationNotVTNRiskReal = [140, 35, 131, 7, 79, 3, 80];
bestCombinationNotVTNRiskCalculado = [157, 127, 129, 85, 44, 154, 131];
bestCombinationNotVTNInstability = [22, 127, 128, 138];
%Topology
bestCombinationTopologyRiskReal = [22, 25, 47, 80, 79, 84, 77];
bestCombinationTopologyRiskCalculado = [72, 77, 102, 41, 25, 2, 88];
bestCombinationTopologyInstability = [72, 25, 60, 22, 57, 31, 48];
%NoTopology
bestCombinationNoTopologyRiskReal = [136, 66, 69, 34, 133, 155, 64];
bestCombinationNoTopologyRiskCalculado = [157, 127, 129, 85, 44, 154, 131];
bestCombinationNoTopologyInstability = [59, 69, 136];
%VTN
bestCombinationVTNRiskReal = [69, 65, 71, 46, 47, 110, 50];
bestCombinationVTNRiskCalculado = [109, 65, 72, 58, 51, 57, 61];
bestCombinationVTNInstability = [108, 109, 110, 47, 63, 59];
bestCombinationVTNExitus = [113,59,72,58,75,76,111];
bestCombinationVTNRecaida = [72,46,53,59,58,108,118];
%VTN Topology
bestCombinationVTNTopologyRiskReal = [72, 47, 50, 65, 73, 46, 75];
bestCombinationVTNTopologyRiskCalculado = [72, 50, 58, 56, 65, 61, 63];
bestCombinationVTNTopologyInstability = [72, 47, 60, 65, 71, 50, 63];
bestCombinationVTNTopologyExitus = [65,60,70,58,47,50,46];
bestCombinationVTNTopologyRecaida = [72,46,47,50,58,56,61];
%VTN NonTopological
bestCombinationVTNNonTopologicalRiskReal = [109, 49, 119, 64, 120, 118, 121];
bestCombinationVTNNonTopologicalRiskCalculado = [109, 66, 120, 121, 118, 119, 122];
bestCombinationVTNNonTopologicalInstability = [109, 51, 108, 74, 68, 64, 59];
bestCombinationVTNNonTopologicalExitus = [120,74,109,64,117,119,118];
bestCombinationVTNNonTopologicalRecaida = [120,53,113,68,119,117,118];
%VTN Extracellular
bestCombinationVTNExtracellularRiskReal = [47, 51, 54, 119, 58, 56, 52];
bestCombinationVTNExtracellularRiskCalculado = [54, 51, 55, 57, 53, 47, 46];
bestCombinationVTNExtracellularInstability = [118, 54, 110, 111, 47, 57, 59];
%VTN Intra/pericellular
bestCombinationVTNpericellularRiskReal = [69, 65, 71, 63, 61, 75, 113];
bestCombinationVTNpericellularRiskCalculado = [72, 64, 68, 63, 62, 75, 71];
bestCombinationVTNpericellularInstability = [69, 64, 72, 75, 74, 62, 61];

%check this
inrgFeatures = 162:169;
%Best morphometrics VTN features
bestVTNMorphometricsFeatures = [109 108 110 112 118 119 120 122];


%% BestCombinations divided by category
% Instability
bestCombinationsInstability = {};
bestCombinationsInstability = {bestCombinationsInstability{:}, bestCombinationAllInstability, bestCombinationNotVTNInstability};
bestCombinationsInstability = {bestCombinationsInstability{:}, bestCombinationTopologyInstability, bestCombinationNoTopologyInstability};
bestCombinationsInstability = {bestCombinationsInstability{:}, bestCombinationVTNInstability, bestCombinationVTNTopologyInstability};
bestCombinationsInstability = {bestCombinationsInstability{:}, bestCombinationVTNNonTopologicalInstability, bestCombinationVTNExtracellularInstability};
bestCombinationsInstability = {bestCombinationsInstability{:}, bestCombinationVTNpericellularInstability};

% RiskReal
bestCombinationsRiskReal = {};
bestCombinationsRiskReal = {bestCombinationsRiskReal{:}, bestCombinationAllRiskReal, bestCombinationNotVTNRiskReal, bestCombinationTopologyRiskReal};
bestCombinationsRiskReal = {bestCombinationsRiskReal{:}, bestCombinationNoTopologyRiskReal, bestCombinationVTNRiskReal, bestCombinationVTNTopologyRiskReal};
bestCombinationsRiskReal = {bestCombinationsRiskReal{:}, bestCombinationVTNNonTopologicalRiskReal, bestCombinationVTNExtracellularRiskReal};
bestCombinationsRiskReal = {bestCombinationsRiskReal{:}, bestCombinationVTNpericellularRiskReal};

% RiskCalculated
bestCombinationsRiskCalculated = {};
bestCombinationsRiskCalculated = {bestCombinationsRiskCalculated{:}, bestCombinationAllRiskCalculado, bestCombinationNotVTNRiskCalculado};
bestCombinationsRiskCalculated = {bestCombinationsRiskCalculated{:}, bestCombinationTopologyRiskCalculado, bestCombinationNoTopologyRiskCalculado};
bestCombinationsRiskCalculated = {bestCombinationsRiskCalculated{:}, bestCombinationVTNRiskCalculado, bestCombinationVTNTopologyRiskCalculado};
bestCombinationsRiskCalculated = {bestCombinationsRiskCalculated{:}, bestCombinationVTNNonTopologicalRiskCalculado, bestCombinationVTNExtracellularRiskCalculado};
bestCombinationsRiskCalculated = {bestCombinationsRiskCalculated{:}, bestCombinationVTNpericellularRiskCalculado};

% Exitus
bestCombinationsExitus = {};
bestCombinationsExitus = {bestCombinationsExitus{:}, bestCombinationVTNExitus, bestCombinationVTNTopologyExitus};
bestCombinationsExitus = {bestCombinationsExitus{:}, bestCombinationVTNNonTopologicalExitus};

% Recaida
bestCombinationsRecaida = {};
bestCombinationsRecaida = [bestCombinationsRecaida, bestCombinationVTNRecaida, bestCombinationVTNTopologyRecaida];
bestCombinationsRecaida = [bestCombinationsRecaida, bestCombinationVTNNonTopologicalRecaida];


bestCombinations = {};
%bestCombinations = {bestCombinationAllRiskReal, bestCombinationAllRiskCalculado, bestCombinationAllInstability};
%bestCombinations = {bestCombinations{:}, bestCombinationNotVTNRiskReal, bestCombinationNotVTNRiskCalculado, bestCombinationNotVTNInstability};
%bestCombinations = {bestCombinations{:}, bestCombinationTopologyRiskReal, bestCombinationTopologyRiskCalculado, bestCombinationTopologyInstability};
%bestCombinations = {bestCombinations{:}, bestCombinationNoTopologyRiskReal, bestCombinationNoTopologyRiskCalculado, bestCombinationNoTopologyInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNRiskReal, bestCombinationVTNRiskCalculado, bestCombinationVTNInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNTopologyRiskReal, bestCombinationVTNTopologyRiskCalculado, bestCombinationVTNTopologyInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNNonTopologicalRiskReal, bestCombinationVTNNonTopologicalRiskCalculado, bestCombinationVTNNonTopologicalInstability};
%bestCombinations = {bestCombinations{:}, bestCombinationVTNExtracellularRiskReal, bestCombinationVTNExtracellularRiskCalculado, bestCombinationVTNExtracellularInstability};
%bestCombinations = {bestCombinations{:}, bestCombinationVTNpericellularRiskReal, bestCombinationVTNpericellularRiskCalculado, bestCombinationVTNpericellularInstability};

% %% Age
% warning('off', 'all')
% emptyCells = arrayfun(@(x) isequal('', x), matrixInit.Age);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.Age;
% noRiskLabels = arrayfun(@(x) x < 18, labelsUsed);
% labelsUsed = cell(size(labelsUsed));
% labelsUsed(noRiskLabels) = {'LowerAge'};
% labelsUsed(noRiskLabels == 0) = {'GreaterAge'};

disp('Age category');
%[ ftcAgeTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'GreaterAge', topologicalFeatures );
%ftcAgeTopologicalOnlyTopFeaturesFinal = getBestFTC({ftcAgeTopologicalOnlyTopFeatures});
% resultsAge = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'GreaterAge');


%% Location or Metastasis
% emptyCells = arrayfun(@(x) isequal(999, x), matrixInit.INRG_LOCAvsMETAST);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.INRG_LOCAvsMETAST;
% noRiskLabels = arrayfun(@(x) x == 0, labelsUsed);
% labelsUsed = cell(size(labelsUsed));
% labelsUsed(noRiskLabels) = {'Localized'};
% labelsUsed(noRiskLabels == 0) = {'Metastasis'};

disp('Location or Metastasis category');
%[ ftcLocaVsMetaTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Metastasis', topologicalFeatures );
% ftcLocaVsMetaTopologicalOnlyTopFeaturesFinal = getBestFTC({ftcLocaVsMetaTopologicalOnlyTopFeatures});
% resultsLocaVsMeta = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'Metastasis');


%% Histopathology
% emptyCells = arrayfun(@(x) isequal(999, x), matrixInit.INRG_HISTOP);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.INRG_HISTOP;
% noRiskLabels = arrayfun(@(x) x < 2, labelsUsed);
% labelsUsed = cell(size(labelsUsed));
% labelsUsed(noRiskLabels) = {'BetterHisto'};
% labelsUsed(noRiskLabels == 0) = {'WorseHisto'};

disp('Histopathology category');
% [ ftcHistopathologyTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'WorseHisto', topologicalFeatures );
% ftcHistopathologyTopologicalOnlyTopFeaturesFinal = getBestFTC({ftcHistopathologyTopologicalOnlyTopFeatures});
% resultsHistopathology = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'WorseHisto');

%% NMYC
emptyCells = arrayfun(@(x) isequal(999, x), matrixInit.INRG_MYCN);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.INRG_MYCN;
noRiskLabels = arrayfun(@(x) x < 1, labelsUsed);
labelsUsed = cell(size(labelsUsed));
labelsUsed(noRiskLabels) = {'NoMYCN'};
labelsUsed(noRiskLabels == 0) = {'MYCN'};

disp('NMYC category');
% [ ftcMYCNTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'MYCN', topologicalFeatures );
% ftcMYCNTopologicalOnlyTopFeaturesFinal = getBestFTC({ftcMYCNTopologicalOnlyTopFeatures});
% resultsMYCN = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'MYCN');

%% 11q
emptyCells = arrayfun(@(x) isequal(999, x), matrixInit.INRG_11q);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.INRG_11q;
noRiskLabels = arrayfun(@(x) x < 1, labelsUsed);
labelsUsed = cell(size(labelsUsed));
labelsUsed(noRiskLabels) = {'No11q'};
labelsUsed(noRiskLabels == 0) = {'11q'};

disp('11q category');
% [ ftc11qTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, '11q', topologicalFeatures );
% ftc11qTopologicalOnlyTopFeaturesFinal = getBestFTC({ftc11qTopologicalOnlyTopFeatures});
% results11q = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, '11q');

%% SCA
% emptyCells = arrayfun(@(x) x > 2, matrixInit.SCA);
% matrix2 = matrixInit(emptyCells == 0, :);
% matrixChar = table2array(matrix2(:, initialIndex:end));
% labelsUsed = matrix2.SCA;
% noRiskLabels = arrayfun(@(x) x < 1, labelsUsed);
% labelsUsed = cell(size(labelsUsed));
% labelsUsed(noRiskLabels) = {'NoSCA'};
% labelsUsed(noRiskLabels == 0) = {'SCA'};

disp('SCA category');
% [ ftcSCATopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'SCA', topologicalFeatures );
% ftcSCATopologicalOnlyTopFeaturesFinal = getBestFTC({ftcSCATopologicalOnlyTopFeatures});
% resultsSCA = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'SCA');

%% Exitus
disp('Exitus category');
emptyCells = isnan(matrixInit.NEUPAT_exitus);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.NEUPAT_exitus;
noRiskLabels = logical(labelsUsed);
labelsUsed = cell(length(labelsUsed), 1);
labelsUsed(noRiskLabels) = {'Exitus'};
labelsUsed(noRiskLabels == 0) = {'Alive'};

%[ ftcExitusOnlyTopFeatures ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Exitus', 1:size(matrixChar, 2) );
% [ ftcExitusVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Exitus', vtnChar );
% [ ftcExitusVTNTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Exitus', setdiff(vtnChar, nonTopologicalFeatures) );
% [ ftcExitusVTNNonTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Exitus', setdiff(vtnChar, topologicalFeatures) );
% bestFTCs_Exitus = getBestFTC({ftcExitusVTNOnlyTopFeatures, ftcExitusVTNTopologyTopFeatures, ftcExitusVTNNonTopologyTopFeatures});

% for numDataset = 1:length(bestCombinationsExitus)
%     [ ftcExitusBestCombination{numDataset, 1} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Exitus', horzcat(bestCombinationsExitus{numDataset}, inrgFeatures) );
%     [ ftcExitusBestCombination{numDataset, 2} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Exitus', horzcat(bestVTNMorphometricsFeatures, inrgFeatures) );
%     [ ftcExitusBestCombination{numDataset, 3} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Exitus', unique(horzcat(bestCombinationsExitus{numDataset}, bestVTNMorphometricsFeatures, inrgFeatures) ));
% end
% bestFTCs_Exitus_BestCombination = getBestFTC(ftcExitusBestCombination);



%% Recaida
disp('Recaida category');
emptyCells = isnan(matrixInit.NEUPAT_recaida);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.NEUPAT_recaida;
noRiskLabels = logical(labelsUsed);
labelsUsed = cell(length(labelsUsed), 1);
labelsUsed(noRiskLabels) = {'Recaida'};
labelsUsed(noRiskLabels == 0) = {'NoRecaida'};

% [ ftcRecaidaVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Recaida', vtnChar );
% [ ftcRecaidaVTNTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Recaida', setdiff(vtnChar, nonTopologicalFeatures) );
% [ ftcRecaidaVTNNonTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Recaida', setdiff(vtnChar, topologicalFeatures) );
% bestFTCs_Recaida = getBestFTC({ftcRecaidaVTNOnlyTopFeatures, ftcRecaidaVTNTopologyTopFeatures, ftcRecaidaVTNNonTopologyTopFeatures});
% 
% for numDataset = 1:length(bestCombinationsRecaida)
%     [ ftcRecaidaBestCombination{numDataset, 1} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Recaida', horzcat(bestCombinationsRecaida{numDataset}, inrgFeatures) );
%     [ ftcRecaidaBestCombination{numDataset, 2} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Recaida', horzcat(bestVTNMorphometricsFeatures, inrgFeatures) );
%     [ ftcRecaidaBestCombination{numDataset, 3} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'Recaida', unique(horzcat(bestCombinationsRecaida{numDataset}, bestVTNMorphometricsFeatures, inrgFeatures) ));
% end
% bestFTCs_Recaida_BestCombination = getBestFTC(ftcRecaidaBestCombination);



%% RiskREAL
warning('off', 'all')
disp('RiskREAL category');
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskReal;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};

% for numDataset = 1:(size(bestCombinations, 2)/3)
%     actualDataset = ((numDataset-1)*3)+1;
%     [ ftcRiskRealBestCombination{numDataset} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', horzcat(bestCombinations{actualDataset}, inrgFeatures) );
% end
%bestFTCs_RiskReal_BestCombination = getBestFTC(ftcRiskRealBestCombination);

% % All the executions
% [ ftcRiskRealOnlyTopFeatures ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', 1:size(matrixChar, 2) );
% [ ftcRiskRealVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnChar );
% [ ftcRiskRealVTNTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', setdiff(vtnChar, nonTopologicalFeatures) );
% [ ftcRiskRealVTNNonTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', setdiff(vtnChar, topologicalFeatures) );
% [ ftcRiskRealNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', notVtnChar );
% [ ftcRiskRealTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', topologicalFeatures );
% [ ftcRiskRealNonTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', nonTopologicalFeatures );
% [ ftcRiskRealVTNWeakModerateOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnWeakModerateChar );
% [ ftcRiskRealVTNIntenseOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnIntenseChar );
% %[ ftcRiskRealVTNHomogeneityIndexOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', homogeneityIndexVTN );
% 
% save(strcat('results\NB\NBResultsWithTopFeatures_RiskReal_', date), 'ftcRiskRealOnlyTopFeatures', 'ftcRiskRealVTNOnlyTopFeatures', 'ftcRiskRealVTNTopologyTopFeatures', 'ftcRiskRealVTNNonTopologyTopFeatures', 'ftcRiskRealNotVTNOnlyTopFeatures', 'ftcRiskRealTopologicalOnlyTopFeatures', 'ftcRiskRealNonTopologicalOnlyTopFeatures', 'ftcRiskRealVTNWeakModerateOnlyTopFeatures', 'ftcRiskRealVTNIntenseOnlyTopFeatures');

%% RiskCalculated
disp('RiskCalculated category');
warning('off', 'all')
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskCalculated);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskCalculated;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};

% for numDataset = 1:(size(bestCombinations, 2)/3)
%     actualDataset = ((numDataset-1)*3)+2;
%     [ ftcRiskCalculatedBestCombination{numDataset} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', horzcat(bestCombinations{actualDataset}, inrgFeatures) );
% end
%ftcRiskCalculatedBestCombinationFinal = getBestFTC(ftcRiskCalculatedBestCombination);

for numDataset = 1:length(bestCombinationsRiskCalculated)
    [ ftcRiskCalculatedBestCombination{numDataset, 1} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', horzcat(bestCombinationsRiskCalculated{numDataset}, inrgFeatures) );
    [ ftcRiskCalculatedBestCombination{numDataset, 2} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', horzcat(bestVTNMorphometricsFeatures, inrgFeatures) );
    [ ftcRiskCalculatedBestCombination{numDataset, 3} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', unique(horzcat(bestCombinationsRiskCalculated{numDataset}, bestVTNMorphometricsFeatures, inrgFeatures) ));
end
%bestFTCs_RiskCalculated_BestCombination = getBestFTC(ftcRiskCalculatedBestCombination);

% % All the executions
% [ ftcRiskCalculatedVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnChar );
% [ ftcRiskCalculatedVTNTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', setdiff(vtnChar, nonTopologicalFeatures));
% [ ftcRiskCalculatedVTNNonTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', setdiff(vtnChar, topologicalFeatures));
% [ ftcRiskCalculatedNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', notVtnChar );
% [ ftcRiskCalculatedTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', topologicalFeatures );
% [ ftcRiskCalculatedNonTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', nonTopologicalFeatures );
% [ ftcRiskCalculatedOnlyTopFeatures ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', 1:size(matrixChar, 2) );
% [ ftcRiskCalculatedVTNWeakModerateOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnWeakModerateChar );
% [ ftcRiskCalculatedVTNIntenseOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', vtnIntenseChar );
% %[ ftcRiskCalculatedVTNHomogeneityIndexOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'HighRisk', homogeneityIndexVTN );


%save(strcat('results\NB\NBResultsWithTopFeatures_RiskCalculated_', date), 'ftcRiskCalculatedOnlyTopFeatures', 'ftcRiskCalculatedVTNOnlyTopFeatures', 'ftcRiskCalculatedVTNTopologyTopFeatures', 'ftcRiskCalculatedVTNNonTopologyTopFeatures', 'ftcRiskCalculatedNotVTNOnlyTopFeatures', 'ftcRiskCalculatedTopologicalOnlyTopFeatures', 'ftcRiskCalculatedNonTopologicalOnlyTopFeatures', 'ftcRiskCalculatedVTNWeakModerateOnlyTopFeatures', 'ftcRiskCalculatedVTNIntenseOnlyTopFeatures');

%% High Instability vs Rest
disp('Instability category');
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Rest'};



% for numDataset = 1:(size(bestCombinations, 2)/3)
%     actualDataset = numDataset*3;
%     [ ftcInstabilityBestCombination{numDataset} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'High', horzcat(bestCombinations{actualDataset}, inrgFeatures) );
% end
%ftcInstabilityBestCombinationFinal = getBestFTC(ftcInstabilityBestCombination);
%[ ftcInstabilityVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnChar );

% for numDataset = 1:length(bestCombinationsInstability)
%     [ ftcInstabilityBestCombination{numDataset, 1} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'High', horzcat(bestCombinationsInstability{numDataset}, inrgFeatures) );
%     [ ftcInstabilityBestCombination{numDataset, 2} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'High', horzcat(bestVTNMorphometricsFeatures, inrgFeatures) );
%     [ ftcInstabilityBestCombination{numDataset, 3} ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'High', unique(horzcat(bestCombinationsInstability{numDataset}, bestVTNMorphometricsFeatures, inrgFeatures) ));
% end
% bestFTCs_Instability_BestCombination = getBestFTC(ftcInstabilityBestCombination);

%% High Instability vs Medium Instability
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
riskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
noRiskLabels = cellfun(@(x) isequal(x, 'Medium'), labelsUsed);
%labelsUsed(noRiskLabels == 0) = {'Rest'};
[ ftcInstabilityVTNOnlyTopFeatures2 ] = getFTCWithTopFeatures(labelsUsed(noRiskLabels | riskLabels), matrixChar(noRiskLabels | riskLabels, :), columnNames, 'High', vtnChar );
bestFTCs_MediumHigh = getBestFTC({ftcInstabilityVTNOnlyTopFeatures});


%% High+Mediium Instability vs Low+VeryLow Instability
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
noRiskLabels = cellfun(@(x) isequal(x, 'High') | isequal(x, 'Medium'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Low'};
labelsUsed(noRiskLabels) = {'High'};


%[ ftcInstabilityOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', 1:size(matrixChar, 2) );
%[ ftcInstabilityMediumHighVsLowVeryLowVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnChar );
%[ ftcInstabilityMediumHighVsLowVeryLowVTNTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', setdiff(vtnChar, nonTopologicalFeatures) );
%[ ftcInstabilityMediumHighVsLowVeryLowVTNNonTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', setdiff(vtnChar, topologicalFeatures) );
%[ ftcInstabilityNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', notVtnChar );
%[ ftcInstabilityTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', topologicalFeatures );
%[ ftcInstabilityNonTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', nonTopologicalFeatures );
%[ ftcInstabilityVTNWeakModerateOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnWeakModerateChar );
%[ ftcInstabilityVTNIntenseOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnIntenseChar );
% % [ ftcInstabilityVTNHomogeneityIndexOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', homogeneityIndexVTN );

%save(strcat('results\NB\NBResultsWithTopFeatures_InstabilityMediumHighVsLowVeryLow_', date), 'ftcInstabilityOnlyTopFeatures', 'ftcInstabilityVTNOnlyTopFeatures', 'ftcInstabilityVTNTopologyTopFeatures', 'ftcInstabilityVTNNonTopologyTopFeatures', 'ftcInstabilityNotVTNOnlyTopFeatures', 'ftcInstabilityTopologicalOnlyTopFeatures', 'ftcInstabilityNonTopologicalOnlyTopFeatures', 'ftcInstabilityVTNWeakModerateOnlyTopFeatures', 'ftcInstabilityVTNIntenseOnlyTopFeatures');


% data = getBestFTC({ftcRiskCalculatedVTNOnlyTopFeatures});
% data = data{1};
% getHowGoodAreTheseCharacteristics(data.matrixAllCases(:, data.indicesCcsSelected), noRiskLabels+1, -1, 'LogisticRegression')
% 
% regressionResults = [0.576947432957364;0.996765358280107;0.966099555211866;0.978907402420262;0.997433648369966;0.679104196070442;0.147745429716695;0.476802934496753;0.250447470858355;0.0526709353014306;0.231174041041147;0.451822473950908;0.0908011374905511;0.275507395895127;0.868248819027860;0.232409133301413;0.0462035259871495;0.205850684487634;0.203636472895767;0.106128199100096;0.147712431760583;0.270889124243916;0.277790308787048;0.132211815540724;0.350021455178916;0.0263830456565385;0.396214562887083;0.514249234491741;0.179273954022986;0.288653599230203;0.756368912302849;0.688288237923654;0.102867197467626;0.411672894051358;0.138219892623603;0.225365464092597;0.877634274833296;0.0914934228476421;0.700750501699833;0.115262387526308;0.607371252666806;0.485937179547972;0.106742916012638;0.433442196648285;0.0479393079691534;0.909959679655982;0.315476236400471;0.296049925390998;0.230954175445333;0.153266231700692;0.182089364123852;0.0531968312205019;0.210891099947444;0.0607227131404400;0.997928924733675;0.0630405677616530;0.436930864322477;0.421697259856047;0.819487248478775;0.181646966650653;0.809492217564121;0.119280579477964;0.190424234012936;0.168209648409231;0.652104296877709;0.926407781324469;0.288596050582676;0.264755394420791;0.0794774342424925;0.790514544882578;0.565121023615241;0.379290097787808;0.961526721769189;0.999191393817326;0.841336212870055;0.988901651424619;0.765110793964731;0.673964291692852;0.930495570986971;0.997416779986439;0.121716318565699;0.945867056020859];
% 
% Mdl = fitrtree(data.initialMatrix(:, data.indicesCcsSelected), regressionResults, 'predictorNames', data.ccsSelected);
% 
% %Mdl = fitctree(data.initialMatrix(:, data.indicesCcsSelected), data.labels, 'predictorNames', data.ccsSelected);
% view(Mdl, 'Mode', 'graph')

warning('on', 'all')