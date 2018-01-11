function [ res,  bestFeatures] = getBestFeatures(numBestFeatures, matrixInit, ftc, initialIndex )
%GETBESTFEATURES Summary of this function goes here
%   Detailed explanation goes here
res = [];
%filter = cellfun(@(x) isequal(x, 'Low') | isequal(x, 'VeryLow'), ftc.labels);
emptyCells = cellfun(@(x) isequal('', x), matrixInit.Instability);
matrix2 = matrixInit(emptyCells == 0, :);
labelsUsed = matrix2.Instability;
matrixChar = table2array(matrix2(:, initialIndex:end));
noRiskLabels = cellfun(@(x) isequal(x, 'High'), labelsUsed);
filter = 1:size(ftc.matrixAllCases, 1);
characteristics = 1:size(columnNames, 2);
for idChar = characteristics
    [ goodness, ~, sensitivity, specificity] = getHowGoodAreTheseCharacteristics(ftc.matrixAllCases(filter, idChar), noRiskLabels + 1, ones(size(matrixChar(filter, :), 1), 1), 'LogisticRegression');
    [h,p,~,~] = ttest2(matrixChar(noRiskLabels == 0, idChar), matrixChar(noRiskLabels, idChar), 'Vartype', 'unequal', 'Alpha', 0.1);
    res(idChar, :) = [idChar, specificity, sensitivity, 1 - goodness, p, h];
end
[res, indices] = sortrows(res, 4);
indicesNames = columnNames(indices);

bestFeatures = indices(res(:, numBestFeatures));
end

