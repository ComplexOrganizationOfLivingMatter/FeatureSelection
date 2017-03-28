function [ arrayNormalized ] = normalizeVector(arrayToNormalized)
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
    for numCol = 1:size(arrayToNormalized, 2)
            %arrayNormalized(:,numCol) = arrayToNormalized(:, numCol) - min(arrayToNormalized(:, numCol));
            arrayNormalized(:,numCol) = arrayToNormalized(:, numCol) / sum(abs(arrayToNormalized(:, numCol)));
    end
    arrayNormalized(isnan(arrayNormalized)) = 0;
end