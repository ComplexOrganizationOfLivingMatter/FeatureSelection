function [ ftcOnlyTopFeatures, newFtc ] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, condition, usedChars )
%GETFTCWITHTOPFEATURES Summary of this function goes here
%   Detailed explanation goes here
    ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', usedChars, columnNames, condition);
    % newFtc = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
    [~, preSelectedFeatures] = ftc.getBestFeatures(10);
    ftcOnlyTopFeatures = {};
    parfor numFeature = 1:length(preSelectedFeatures)
        warning('off', 'all')
        ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', usedChars , columnNames, condition);
        ftc.preSelectedFeature = preSelectedFeatures(numFeature);
        ftcOnlyTopFeatures{numFeature} = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
    end
end

