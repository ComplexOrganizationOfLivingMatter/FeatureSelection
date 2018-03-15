
cd 'D:\Pablo\FeatureSelection\FeatureSelection\'
addpath(genpath('src'))
addpath(genpath('lib'))

%% Logistic regression
%uiopen('D:\Pablo\Neuroblastoma\Results\graphletsCount\NuevosCasos\Analysis\NewClinicClassification_NewControls_11_01_2018.xlsx',1);
matrixInit = NewClinicClassificationNewControls11012018;
%matrixInit.VTNHSCORE = [];
initialIndex = 47%:(47+161);
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
%VTN Topology
bestCombinationVTNTopologyRiskReal = [72, 47, 50, 65, 73, 46, 75];
bestCombinationVTNTopologyRiskCalculado = [72, 50, 58, 56, 65, 61, 63];
bestCombinationVTNTopologyInstability = [72, 47, 60, 65, 71, 50, 63];
%VTN NonTopological
bestCombinationVTNNonTopologicalRiskReal = [109, 49, 119, 64, 120, 118, 121];
bestCombinationVTNNonTopologicalRiskCalculado = [109, 66, 120, 121, 118, 119, 122];
bestCombinationVTNNonTopologicalInstability = [109, 51, 108, 74, 68, 64, 59];
%VTN Extracellular
bestCombinationVTNExtracellularRiskReal = [47, 51, 54, 119, 58, 56, 52];
bestCombinationVTNExtracellularRiskCalculado = [54, 51, 55, 57, 53, 47, 46];
bestCombinationVTNExtracellularInstability = [118, 54, 110, 111, 47, 57, 59];
%VTN Intra/pericellular
bestCombinationVTNpericellularRiskReal = [69, 65, 71, 63, 61, 75, 113];
bestCombinationVTNpericellularRiskCalculado = [72, 64, 68, 63, 62, 75, 71];
bestCombinationVTNpericellularInstability = [69, 64, 72, 75, 74, 62, 61];

addedFeatures = 162:167;

bestCombinations = {bestCombinationAllRiskReal, bestCombinationAllRiskCalculado, bestCombinationAllInstability};
bestCombinations = {bestCombinations{:}, bestCombinationNotVTNRiskReal, bestCombinationNotVTNRiskCalculado, bestCombinationNotVTNInstability};
bestCombinations = {bestCombinations{:}, bestCombinationTopologyRiskReal, bestCombinationTopologyRiskCalculado, bestCombinationTopologyInstability};
bestCombinations = {bestCombinations{:}, bestCombinationNoTopologyRiskReal, bestCombinationNoTopologyRiskCalculado, bestCombinationNoTopologyInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNRiskReal, bestCombinationVTNRiskCalculado, bestCombinationVTNInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNTopologyRiskReal, bestCombinationVTNTopologyRiskCalculado, bestCombinationVTNTopologyInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNNonTopologicalRiskReal, bestCombinationVTNNonTopologicalRiskCalculado, bestCombinationVTNNonTopologicalInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNExtracellularRiskReal, bestCombinationVTNExtracellularRiskCalculado, bestCombinationVTNExtracellularInstability};
bestCombinations = {bestCombinations{:}, bestCombinationVTNpericellularRiskReal, bestCombinationVTNpericellularRiskCalculado, bestCombinationVTNpericellularInstability};

%% Age
warning('off', 'all')
emptyCells = arrayfun(@(x) isequal('', x), matrixInit.Age);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Age;
noRiskLabels = arrayfun(@(x) x < 18, labelsUsed);
labelsUsed = cell(size(labelsUsed));
labelsUsed(noRiskLabels) = {'LowerAge'};
labelsUsed(noRiskLabels == 0) = {'GreaterAge'};

disp('Age category');
%[ ftcAgeTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'GreaterAge', topologicalFeatures );
resultsAge = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'GreaterAge');


%% Location or Metastasis
emptyCells = arrayfun(@(x) isequal(999, x), matrixInit.INRG_LOCAvsMETAST);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.INRG_LOCAvsMETAST;
noRiskLabels = arrayfun(@(x) x == 0, labelsUsed);
labelsUsed = cell(size(labelsUsed));
labelsUsed(noRiskLabels) = {'Localized'};
labelsUsed(noRiskLabels == 0) = {'Metastasis'};

disp('Location or Metastasis category');
%[ ftcLocaVsMetaTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'Metastasis', topologicalFeatures );
resultsLocaVsMeta = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'Metastasis');


%% Histopathology
emptyCells = arrayfun(@(x) isequal(999, x), matrixInit.INRG_HISTOP);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.INRG_HISTOP;
noRiskLabels = arrayfun(@(x) x < 3, labelsUsed);
labelsUsed = cell(size(labelsUsed));
labelsUsed(noRiskLabels) = {'BetterHisto'};
labelsUsed(noRiskLabels == 0) = {'WorseHisto'};

disp('Histopathology category');
%[ ftcHistopathologyTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'WorseHisto', topologicalFeatures );
resultsHistopathology = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'WorseHisto');

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
[ ftcMYCNTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'MYCN', topologicalFeatures );
resultsMYCN = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'MYCN');

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
[ ftc11qTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, '11q', topologicalFeatures );
results11q = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, '11q');

%% SCA
emptyCells = arrayfun(@(x) x > 2, matrixInit.SCA);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.SCA;
noRiskLabels = arrayfun(@(x) x < 1, labelsUsed);
labelsUsed = cell(size(labelsUsed));
labelsUsed(noRiskLabels) = {'NoSCA'};
labelsUsed(noRiskLabels == 0) = {'SCA'};

disp('SCA category');
[ ftcSCATopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'SCA', topologicalFeatures );
resultsSCA = testCombinationsOfFeatures(bestCombinations, labelsUsed, matrixChar, columnNames, 'SCA');

%% RiskREAL
warning('off', 'all')
disp('RiskREAL category');
emptyCells = cellfun(@(x) isequal('', x), matrixInit.RiskReal);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.RiskReal;
noRiskLabels = cellfun(@(x) isequal(x, 'NoRisk'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'HighRisk'};

for numDataset = 1:(size(bestCombinations, 1)/3)
    actualDataset = ((numDataset-1)*3)+1;
    [ ftcRiskRealBestCombination(numDataset) ] = getFTCWithTopFeatures( labelsUsed, matrixChar, columnNames, 'HighRisk', horzcat(bestCombinations{actualDataset}, addedFeatures) );
end

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

%% High+Mediium Instability vs Low+VeryLow Instability
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
matrixChar = table2array(matrix2(:, initialIndex:end));
labelsUsed = matrix2.Instability;
noRiskLabels = cellfun(@(x) isequal(x, 'High') | isequal(x, 'Medium'), labelsUsed);
labelsUsed(noRiskLabels == 0) = {'Low'};
labelsUsed(noRiskLabels) = {'High'};


[ ftcInstabilityOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', 1:size(matrixChar, 2) );
[ ftcInstabilityVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnChar );
[ ftcInstabilityVTNTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', setdiff(vtnChar, nonTopologicalFeatures) );
[ ftcInstabilityVTNNonTopologyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', setdiff(vtnChar, topologicalFeatures) );
[ ftcInstabilityNotVTNOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', notVtnChar );
[ ftcInstabilityTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', topologicalFeatures );
[ ftcInstabilityNonTopologicalOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', nonTopologicalFeatures );
[ ftcInstabilityVTNWeakModerateOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnWeakModerateChar );
[ ftcInstabilityVTNIntenseOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', vtnIntenseChar );
% % [ ftcInstabilityVTNHomogeneityIndexOnlyTopFeatures ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, 'High', homogeneityIndexVTN );

%save(strcat('results\NB\NBResultsWithTopFeatures_InstabilityMediumHighVsLowVeryLow_', date), 'ftcInstabilityOnlyTopFeatures', 'ftcInstabilityVTNOnlyTopFeatures', 'ftcInstabilityVTNTopologyTopFeatures', 'ftcInstabilityVTNNonTopologyTopFeatures', 'ftcInstabilityNotVTNOnlyTopFeatures', 'ftcInstabilityTopologicalOnlyTopFeatures', 'ftcInstabilityNonTopologicalOnlyTopFeatures', 'ftcInstabilityVTNWeakModerateOnlyTopFeatures', 'ftcInstabilityVTNIntenseOnlyTopFeatures');

% 
% data = ftcInstabilityVTNTopologyTopFeatures{1,1};
% getHowGoodAreTheseCharacteristics(data.matrixAllCases(:, data.indicesCcsSelected), noRiskLabels+1, -1, 'LogisticRegression')
% 
% regressionResults = [0.881798866125071
% 0.999999957500869
% 0.998055412178193
% 0.999999970909243
% 0.999999981796071
% 2.75413828164824e-10
% 0.000536286542184354
% 0.000448558727237132
% 0.0527088615524835
% 2.03776338464377e-09
% 0.00107582727967988
% 0.870408190268572
% 0.000485042618223861
% 1.03073558978635e-05
% 0.986613667859136
% 0.111072489208186
% 4.00632704906584e-11
% 1.15017654701905e-09
% 0.00123047678107328
% 4.16758318652378e-18
% 0.00411294359962543
% 0.122474546683483
% 0.00217933363795989
% 0.0181407024887300
% 0.0309832070887273
% 7.17367339476816e-16
% 3.62708285114831e-11
% 0.206169162026318
% 0.000370693230224199
% 1.51226277502084e-08
% 0.0443359703539502
% 0.966082483091586
% 0.000642895085260801
% 0.207905026234043
% 0.00110995216684696
% 0.000242017179084649
% 9.89431204307542e-06
% 1.34208244960836e-37
% 0.214277582460543
% 1.29146895042313e-05
% 0.615207678422114
% 0.659458131672609
% 0.00140314565305553
% 0.199611300723978
% 4.35768811701432e-05
% 0.000248943420945802
% 0.0408923545959688
% 0.0252614093149774
% 0.0951773706095156
% 0.00161819368693801
% 4.49122229285919e-07
% 0.000171060547112112
% 2.26095416196546e-05
% 4.01597370392371e-05
% 0.999997876925899
% 2.38369112496900e-05
% 0.729084606754382
% 0.258387680291472
% 0.0336646422389695
% 0.0162940679582881
% 0.00154179466964725
% 1.36713347111972e-06
% 0.00601104537299321
% 0.000689621074706824
% 0.525343250324799
% 0.00366272531090580
% 0.175276735412443
% 0.236348258379318
% 6.38257398207619e-07
% 9.84667510397304e-05
% 0.000322150996875528
% 0.0291939715860796
% 0.999972021994261
% 0.997138419128232
% 0.678172582592173
% 0.999999476590803
% 0.955905982484090
% 0.999999984112829
% 0.990014901584944
% 0.999884420076786
% 0.000645528810740557
% 0.999674322653580];
% 
% Mdl = fitrtree(data.initialMatrix(:, data.indicesCcsSelected), regressionResults, 'predictorNames', data.ccsSelected);
% 
% Mdl = fitctree(data.initialMatrix(:, data.indicesCcsSelected), data.labels, 'predictorNames', data.ccsSelected);
% view(Mdl, 'Mode', 'graph')

warning('on', 'all')