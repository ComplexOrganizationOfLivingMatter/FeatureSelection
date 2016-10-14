function [ ] = analyzeGraphletDistances(currentPath)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    fullPathGraphlet = strcat(currentPath, 'gcd73.txt');
    graphletNameSplitted = strsplit(fullPathGraphlet, '\');
    graphletName = graphletNameSplitted(end);
    graphletName = graphletName{1};

    distanceMatrix = dlmread(fullPathGraphlet, '\t', 1, 1);
    names = importfileNames(fullPathGraphlet);
    
    
    distanceMatrixImages = {};
    sortingNamesImages = {};
    numImages = 20;
    distanceMatrixMean = zeros(numImages);
    for numImage = 1:numImages
        imageFilter = cellfun(@(x) size(strfind(x, strcat('imagen_', num2str(numImage), '_')), 1) > 0, names);

        distanceMatrixImages(end+1) = {distanceMatrix(imageFilter, imageFilter)};
        sortingNamesImages(end+1) = {names(imageFilter)};
        distanceMatrixMean = distanceMatrixMean + distanceMatrix(imageFilter, imageFilter);
    end
    
    distanceMatrixMean = distanceMatrixMean / numImages;
    save(strcat(currentPath, 'distanceMatrixMean.mat'), 'distanceMatrixMean');
    
    
%     differenceGraphletsSorting = zeros(size(sortingWTMean, 2) - 1, 1);
%     
%     for i = 1:size(differenceGraphletsSorting, 1)
%         differenceGraphletsSorting(i) = sortingWTMean(i + 1) - sortingWTMean(i);
%     end
end

