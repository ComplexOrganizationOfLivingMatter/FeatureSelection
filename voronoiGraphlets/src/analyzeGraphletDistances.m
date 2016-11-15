function [ ] = analyzeGraphletDistances(currentPath, typeOfDistance)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    fullPathGraphlet = strcat(currentPath, typeOfDistance ,'.txt');
    graphletNameSplitted = strsplit(fullPathGraphlet, '\');
    graphletName = graphletNameSplitted(end);
    graphletName = graphletName{1};

    distanceMatrixInit = dlmread(fullPathGraphlet, '\t', 1, 1);
    names = importfileNames(fullPathGraphlet);
    [names, it] = sort(names);
    distanceMatrix = distanceMatrixInit(it, it);
    
    save(strcat(currentPath, 'distanceMatrix', upper(typeOfDistance) ,'.mat'), 'distanceMatrix', 'names');
    
    voronoiDiagram1 = cellfun(@(x) isempty(strfind(x, 'Diagrama_01')) == 0 & isempty(strfind(x, 'weight')), names);
    distanceMatrix = distanceMatrix(voronoiDiagram1 == 0, voronoiDiagram1);
    distanceMatrix = distanceMatrix(2:end, :);
    differenceMean = mean(distanceMatrix, 2);
    names = names(voronoiDiagram1 == 0);
    names = names(2:end);
    
    save(strcat(currentPath, 'distanceMatrixVoronoi1', upper(typeOfDistance) ,'.mat'), 'distanceMatrix', 'names', 'differenceMean');
end

