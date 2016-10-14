function [ ] = analyzeGraphletDistances(currentPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    fullPathGraphlet = strcat(currentPath, 'gcd73.txt');
    graphletNameSplitted = strsplit(fullPathGraphlet, '\');
    graphletName = graphletNameSplitted(end);
    graphletName = graphletName{1};

    distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
    names = importfileNames(fullPathGraphlet);
    [names, it] = sort(names);
    distanceMatrix = distanceMatrix(it, it);
    
    distanceMatrixImages = {};
    sortingNamesImages = {};
    numImages = 20;
    biologicalImages = cellfun(@(x) size(strfind(x, 'imagen_'), 1) == 0, names);
    distanceMatrixMean = zeros(sum(biologicalImages), numImages);
    
    for numImage = 1:numImages
        imageFilter = cellfun(@(x) size(strfind(x, strcat('imagen_', num2str(numImage), '_')), 1) > 0, names);

        distanceMatrixImages(end+1) = {distanceMatrix(biologicalImages, imageFilter)};
        
        distanceMatrixMean = distanceMatrixMean + distanceMatrix(biologicalImages, imageFilter);
    end
    
    distanceMatrixMean = distanceMatrixMean / numImages;
    namesSortedOut = names(biologicalImages);
    save(strcat(currentPath, 'distanceMatrixMean.mat'), 'distanceMatrixMean', 'namesSortedOut');
    
%     differenceGraphletsSorting = zeros(size(sortingWTMean, 2) - 1, 1);
%     
%     for i = 1:size(differenceGraphletsSorting, 1)
%         differenceGraphletsSorting(i) = sortingWTMean(i + 1) - sortingWTMean(i);
%     end
end

