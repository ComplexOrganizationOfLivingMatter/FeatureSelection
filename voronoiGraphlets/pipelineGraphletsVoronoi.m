function [  ] = pipelineGraphletsVoronoi( typeOfData )
%PIPELINEGRAPHLETSVORONOI Pipeline of the project
%   From the start to the beggining, all should be done here
%   or, at least, the main functionalities.
%   
%   typeOfData: name of the directory we're using
%
%   Developed by Pablo Vicente-Munuera
    clearvars -except typeOfData
    cd E:\Pablo\PhD-miscelanious\voronoiGraphlets\

    dataDir = strcat('data\', typeOfData);
    %Firstly, we calculate neighbours and valid cells
    
    disp('Calculating neighbours and valid cells');
    Calculate_neighbors_polygon_distribution(dataDir);
    validCellsDir = strcat('results\validCellsMaxPathLength\', typeOfData);
    if exist(validCellsDir, 'dir') ~= 7
        mkdir(validCellsDir);
        mkdir(validCellsDir, 'maxLength4');
        mkdir(validCellsDir, 'maxLength5');
    end
    %ValidCells of max path length 4 and 5.
    disp('Valid cells from ROI');
    getValidCellsFromROI(dataDir, 4, validCellsDir);
    getValidCellsFromROI(dataDir, 5, validCellsDir);
    
    networksDir = strcat('results\networks\', typeOfData);
    if exist(networksDir, 'dir') ~= 7
        mkdir(networksDir);
    end
    
    disp('Creating network');
    createNetworksFromVoronoiDiagrams(strcat(validCellsDir, 'maxLength5\'), networksDir);
    
    
    disp('Leda files...');
    calculateLEDAFilesFromDirectory(networksDir, typeOfData);
    graphletResultsDir = strcat('results\graphletResults\', typeOfData);
    if exist(graphletResultsDir, 'dir') ~= 7
        mkdir(graphletResultsDir);
    end
    
    %Now, we have to wait until .ndump2 are created
    answer = 'n';
    while answer ~= 'y'
        answer = input('Are .ndump2 created? [y/n] ');
    end
    %After that, 
    graphletResultsFilteredDir = strcat('results\graphletResultsFiltered\', typeOfData);
    mkdir(graphletResultsFilteredDir);
    mkdir(graphletResultsFilteredDir, 'maxLength4');
    mkdir(graphletResultsFilteredDir, 'maxLength5');
    
%     for i = 12:73
%         filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5\'), 'finalValidCells', i, strcat('WithGraphlet', num2str(i)));
%     end
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5\'), 'finalValidCells', [9, 15, 23, 24, 36, 37, 38, 39, 52, 53, 54, 55, 56, 57, 58, 59, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73]);
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength4\'), 'finalValidCells', [9, 13:73]);
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength4\'), 'finalValidCells', 13:73);
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5\'), 'finalValidCells', []);
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5\'), 'validCells', []);
    
    distanceDir = strcat('results\distanceMatrix\', typeOfData);
    if exist(distanceDir, 'dir') ~= 7
        mkdir(distanceDir);
        mkdir(distanceDir, 'maxLength4\EveryFile');
        mkdir(distanceDir, 'maxLength5\EveryFile');
    end
    
    getPercentageOfHexagons('results\graphletResultsFiltered\allOriginal\', '');
%     answer = 'n';
%     while lower(answer) ~= 'y'
%         answer = input('Are distances calculated? [y/n] ');
%     end
%     
%     %Calculate distance
%     analyzeGraphletDistances(strcat(distanceDir, 'maxLength4\EveryFile\'), 'gdda');
%     analyzeGraphletDistances(strcat(distanceDir, 'maxLength5\EveryFile\'), 'gdda');
% %     analyzeGraphletDistances(strcat(distanceDir, 'maxLength4\'), 'gcd11');
% %     analyzeGraphletDistances(strcat(distanceDir, 'maxLength5\'), 'gcd11');
% %     analyzeGraphletDistances(strcat(distanceDir, 'maxLength5\'), 'gcd73');
%     
%     unifyDistances();
%     getPercentageOfHexagons('results\graphletResultsFiltered\allOriginal\', '');
%     comparePercentageOfHexagonsAgainstComparisonWithRegularHexagons();
end