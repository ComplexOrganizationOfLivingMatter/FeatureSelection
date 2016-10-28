function [ ] = analyzeGraphletDistances(currentPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    fullPathGraphlet = strcat(currentPath, 'gcd11.txt');
    graphletNameSplitted = strsplit(fullPathGraphlet, '\');
    graphletName = graphletNameSplitted(end);
    graphletName = graphletName{1};

    distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
    names = importfileNames(fullPathGraphlet);
    [names, it] = sort(names);
    distanceMatrix = distanceMatrix(it, it);
    

    save(strcat(currentPath, 'distanceMatrixMeanGCD11.mat'), 'distanceMatrix', 'names');
end

