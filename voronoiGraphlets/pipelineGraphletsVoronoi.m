function [  ] = pipelineGraphletsVoronoi( typeOfData )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera
    clear
    cd E:\Pablo\PhD-miscelanious\voronoiGraphlets\

    dataDir = strcat('data\', typeOfData);
    %Firstly, we calculate neighbours and valid cells
    Calculate_neighbors_polygon_distribution(dataDir);
    validCellsDir = strcat('results\validCellsMaxPathLength\', typeOfData);
    if exist(validCellsDir, 'dir') ~= 7
        mkdir(validCellsDir);
        mkdir(validCellsDir, 'maxLength4');
        mkdir(validCellsDir, 'maxLength5');
    end
    %ValidCells of max path length 4 and 5.
    getValidCellsFromROI(dataDir, 4, validCellsDir);
    getValidCellsFromROI(dataDir, 5, validCellsDir);
    
    networksDir = strcat('results\networks\', typeOfData);
    if exist(networksDir, 'dir') ~= 7
        mkdir(networksDir);
    end
    createNetworksFromVoronoiDiagrams(validCellsDir, networksDir);
    
    calculateLEDAFilesFromDirectory('results\graphletVectors\');
    %Now, we have to wait until .ndump2 are created
    
    %After that, 
    graphletResultsDir = strcat('results\graphletResults\', typeOfData);
    if exist(graphletResultsDir, 'dir') ~= 7
        mkdir(graphletResultsDir);
    end
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength4'));
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5'));
    
    %Calculate distance
    analyzeGraphletDistances
end

