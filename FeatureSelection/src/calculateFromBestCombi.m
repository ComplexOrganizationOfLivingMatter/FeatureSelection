function [ output_args ] = calculateFromBestCombi( labelsUsed, matrixChar, columnNames, condition, usedChars )
%CALCULATEFROMBESTCOMBI Summary of this function goes here
%   Detailed explanation goes here
    ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', usedChars, columnNames, condition);
    ftc.indicesCcsSelected = usedChars;
    [featuresMeans] = ftc.getFeaturesMeans();
    [ goodness, projection, sensitivity, specificity, oddsRatio] = getHowGoodAreTheseCharacteristics(ftc.matrixAllCases(:, usedChars), grp2idx(categorical(ftc.labels)), -1, 'LogisticRegression');
    output_args = {featuresMeans, goodness, projection, sensitivity, specificity, oddsRatio};
end

