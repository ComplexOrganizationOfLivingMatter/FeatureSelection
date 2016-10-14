function [ ] = analyzeGraphletDistances(currentPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    fullPathGraphlet = strcat(currentPath, 'gcd73.txt');
    graphletNameSplitted = strsplit(fullPathGraphlet, '\');
    graphletName = graphletNameSplitted(end);
    graphletName = graphletName{1};

    distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
    names = importfileNames(fullPathGraphlet);
    
    
    
    
    algorithmsFilter = cellfun(@(x) size(strfind(x, 'BetweenPairs'), 1) > 0, names);

    sortingAlgorithm = distanceMatrix(algorithmsFilter == 0, algorithmsFilter == 0);
    sortingNames = names(algorithmsFilter == 0);
    sortingControlFilter = cellfun(@(x) size(strfind(x, 'Control'), 1) > 0, sortingNames);
    sortingWTNames = sortingNames(sortingControlFilter == 0);
    sortingWT = sortingAlgorithm(sortingControlFilter == 0, sortingControlFilter);
    sortingWTMean = mean(sortingWT, 2)';
    differenceGraphletsSorting = zeros(size(sortingWTMean, 2) - 1, 1);

    for i = 1:size(differenceGraphletsSorting, 1)
        differenceGraphletsSorting(i) = sortingWTMean(i + 1) - sortingWTMean(i);
    end
end

