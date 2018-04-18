function [ ftcOnlyTopFeatures] = getFTCWithTopFeatures(labelsUsed, matrixChar, columnNames, condition, usedChars )
%GETFTCWITHTOPFEATURES Summary of this function goes here
%   Detailed explanation goes here
    % newFtc = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
    if length(usedChars) > 10
        [res, preSelectedFeatures] = ftc.getBestFeatures(10);
    else
        [~, preSelectedFeatures] = ftc.getBestFeatures(length(usedChars));
    end
    ftcOnlyTopFeatures = {};
    
    parfor numFeature = 1:length(preSelectedFeatures) %parfor
    %for numFeature = 1
        warning('off', 'all')
        ftc = FeatureSelectionClass(labelsUsed, matrixChar, 'LogisticRegression', usedChars , columnNames, condition);
        ftc.preSelectedFeature = preSelectedFeatures(numFeature);
        ftcOnlyTopFeatures{numFeature} = ftc.executeFeatureSelection(ones(size(ftc.matrixAllCases, 1), 1)');
    end
end

