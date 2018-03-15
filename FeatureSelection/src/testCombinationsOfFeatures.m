function [ results ] = testCombinationsOfFeatures( featuresCombinations, labelsUsed, matrixChar, columnNames, condition)
%TESTCOMBINATIONSOFFEATURES Summary of this function goes here
%   Detailed explanation goes here

    results = cell(length(featuresCombinations), 4);
    parfor numCombination = 1:length(featuresCombinations)
        usedChars = featuresCombinations{numCombination};
        ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', usedChars, columnNames, condition);
        [ goodness, projection, sensitivity, specificity] = getHowGoodAreTheseCharacteristics(ftc.matrixAllCases(:, usedChars), grp2idx(categorical(ftc.labels)), -1, 'LogisticRegression');
        results(numCombination, :) = { goodness, projection, sensitivity, specificity};
    end

end

