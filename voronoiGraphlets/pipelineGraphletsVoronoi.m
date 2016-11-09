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
    if exist(graphletResultsFilteredDir, 'dir') ~= 7
        mkdir(graphletResultsFilteredDir);
        mkdir(graphletResultsFilteredDir, 'maxLength4');
        mkdir(graphletResultsFilteredDir, 'maxLength5');
    end
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength4\'), 'finalValidCells');
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5\'), 'finalValidCells');
    filterByNonValidCells(graphletResultsDir, strcat(validCellsDir, 'maxLength5\'), 'validCells');
    
    distanceDir = strcat('results\distanceMatrix\', typeOfData);
    if exist(distanceDir, 'dir') ~= 7
        mkdir(distanceDir);
        mkdir(distanceDir, 'maxLength4\EveryFile');
        mkdir(distanceDir, 'maxLength5\EveryFile');
    end
    answer = 'n';
    while lower(answer) ~= 'y'
        answer = input('Are distances calculated? [y/n] ');
    end
    
    %Calculate distance
    analyzeGraphletDistances(strcat(distanceDir, 'maxLength4\EveryFile\'), 'gdda');
    analyzeGraphletDistances(strcat(distanceDir, 'maxLength5\EveryFile\'), 'gdda');
%     analyzeGraphletDistances(strcat(distanceDir, 'maxLength4\'), 'gcd11');
%     analyzeGraphletDistances(strcat(distanceDir, 'maxLength5\'), 'gcd11');
%     analyzeGraphletDistances(strcat(distanceDir, 'maxLength5\'), 'gcd73');
    
    comparisonFiles = getAllFiles('results\comparisons\EveryFile\maxLength5\');
    differenceWithRegularHexagon = [];
    namesFinal = {};
    for numFile = 1:size(comparisonFiles,1)
        fullPathImage = comparisonFiles(numFile);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted{end};

        if isequal(imageName, 'distanceMatrixGDDA.mat')
            load(fullPathImage);
            differenceWithRegularHexagon = [differenceWithRegularHexagon, distanceMatrix(1, 2:end)];
            if isempty(namesFinal) == 0
                if size(namesFinal, 1) ~= size(names, 1)
                    names = names';
                end
                namesFinal = [namesFinal, names{2:end}];
            else
                if size(names, 2) == 1
                    names = names';
                end
                namesFinal = names(2:end);
            end
        end
    end

    save('results\comparisons\EveryFile\maxLength5\allDifferences.mat', 'differenceWithRegularHexagon', 'namesFinal');
    getPercentageOfHexagons('results\graphletResultsFiltered\allOriginal\');
    comparePercentageOfHexagonsAgainstComparisonWithRegularHexagons();
end

