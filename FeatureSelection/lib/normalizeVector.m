function [ arrayNormalized ] = normalizeVector(arrayToNormalized)
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
    maxNumber = max(sum(abs(arrayToNormalized(:, :))));
    %maxNumber = 100;
    for numCol = 1:size(arrayToNormalized, 2)
            %arrayNormalized(:,numCol) = arrayToNormalized(:, numCol) - min(arrayToNormalized(:, numCol));
            arrayNormalized(:,numCol) = arrayToNormalized(:, numCol) / maxNumber;
    end
    arrayNormalized(isnan(arrayNormalized)) = 0;
end