function [ ] = filterByNonValidCells( currentPath, neighboursPath, kindOfValidCells, removingGraphlets, lastDirectoryName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    allFilesImages = getAllFiles(currentPath);
    allFilesData = getAllFiles(neighboursPath);
    pathSplitted = strsplit(currentPath, '\');
    typeOfData = pathSplitted{end-1};
    for numFile = 1:size(allFilesImages,1)
        fullPathImage = allFilesImages(numFile);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted{end};
        imageNameReal = imageName(16:end-7);
        
        %if isempty(strfind(imageNameReal, 'Image_10_')) == 0 || isempty(strfind(imageNameReal, 'Image_10_')) == 0
            if isequal(kindOfValidCells, 'finalValidCells')
                outputFile = strrep(neighboursPath, 'validCellsMaxPathLength', 'graphletResultsFiltered');
                if length(removingGraphlets) > 0
                    outputFile = strrep(outputFile, 'maxLength4', lastDirectoryName);
                    outputFile = strrep(outputFile, 'maxLength5', lastDirectoryName);
                    outputDir = strsplit(outputFile, '\');
                    
                    if exist(strjoin(outputDir(1:end-1), '\'), 'dir') ~= 7
                        mkdir(outputDir);
                    end
                end
                outputFile = strcat(outputFile, imageNameReal(1:end-5), '.ndump2');
            else
                outputFile = strcat('results\graphletResultsFiltered\allOriginal\', imageNameReal(1:end-5), '.ndump2');
            end
            if isempty(strfind(outputFile, 'Weighted')) == 0
                outputFileSplitted = strsplit(outputFile, '\');
                outputFileCancer = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\CancerCells\', imageNameReal(1:end-5), '_OnlyWeightedCells.ndump2');
                outputFileCancerNeighbours = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\NeighboursOfCancerCells\', imageNameReal(1:end-5), '_OnlyNeighboursOfWeightedCells.ndump2');
                if exist(outputFileCancer, 'file') ~= 2
                    imageName
                    dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
                    matrixToFilter = csvread(fullPathImage);
                    dataFileName = allFilesData(dataFile);
                    load(dataFileName{1});

                    %load weights
                    imageNameSplitted = strsplit(imageNameReal, '_');
                    weightsFileName = strcat('data\', typeOfData, '\data\', imageNameSplitted{2}, '\', strjoin(imageNameSplitted(9:end-1), '_'), '\', strjoin(imageNameSplitted(3:end), '_'), '.mat');
                    load(weightsFileName);
                    weightedCells = find(wts>0); %and neighbours
                    weightedAndNeighboursValidCells = intersect(finalValidCells, weightedCells);
                    finalMatrixFiltered = matrixToFilter(weightedAndNeighboursValidCells, :); 

                    if size(finalMatrixFiltered, 1) > 6
                        finalMatrixFiltered(:, removingGraphlets) = 0;
                        dlmwrite(outputFileCancer, finalMatrixFiltered, ' ');
                    else
                        fullpathImage
                        disp('Not enough nodes');
                    end
                end
                if exist(outputFileCancerNeighbours, 'file') ~= 2
                    imageName;
                    dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
                    matrixToFilter = csvread(fullPathImage);
                    dataFileName = allFilesData(dataFile);
                    load(dataFileName{1});

                    %load weights
                    imageNameSplitted = strsplit(imageNameReal, '_');
                    weightsFileName = strcat('data\', typeOfData, '\data\', imageNameSplitted{2}, '\', strjoin(imageNameSplitted(9:end-1), '_'), '\', strjoin(imageNameSplitted(3:end), '_'), '.mat');
                    load(weightsFileName);
                    weightedCells = find(wts>0); %and neighbours
                    neighbours = vertcat(vecinos{wts>0}); %and neighbours
                    weightedAndNeighboursValidCells = intersect(finalValidCells, setxor(weightedCells, neighbours));
                    finalMatrixFiltered = matrixToFilter(weightedAndNeighboursValidCells, :); 
                    finalMatrixFiltered = finalMatrixFiltered(finalMatrixFiltered(:, 1) > 0, :);
                    if size(finalMatrixFiltered, 1) > 6
                        finalMatrixFiltered(:, removingGraphlets) = 0;
                        dlmwrite(outputFileCancerNeighbours, finalMatrixFiltered, ' ');
                    else
                        fullpathImage
                        disp('Not enough nodes');
                    end
                end
            elseif exist(outputFile, 'file') ~= 2
                dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
                matrixToFilter = csvread(fullPathImage);
                dataFileName = allFilesData(dataFile);
                load(dataFileName{1});
                
                if isequal(kindOfValidCells, 'finalValidCells')
                    finalMatrixFiltered = matrixToFilter(finalValidCells, :);
                    finalMatrixFiltered(:, removingGraphlets) = 0;
                else
                    finalMatrixFiltered = matrixToFilter(celulas_validas, :);
                end
                
                if size(finalMatrixFiltered, 1) > 6
                    dlmwrite(outputFile, finalMatrixFiltered, ' ');
                else
                    fullPathImage
                    disp('Not enough nodes');
                end
            end
            if isempty(strfind(outputFile, 'Atrophy')) == 0 && isequal(kindOfValidCells, 'finalValidCells')
                outputFileSplitted = strsplit(outputFile, '\');
                outputFileAtrophic = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\atrophicCells\' , outputFileSplitted{end});

                if exist(outputFileAtrophic, 'file') ~= 2
                    dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
                    matrixToFilter = csvread(fullPathImage);
                    dataFileName = allFilesData(dataFile);
                    load(dataFileName{1});
                    finalMatrixFiltered = matrixToFilter(unique(atrophicCells), :);

                    if size(finalMatrixFiltered, 1) >= 6
                        finalMatrixFiltered(:, removingGraphlets) = 0;
                        dlmwrite(outputFileAtrophic, finalMatrixFiltered, ' ');
                    else
                        fullPathImage
                        disp('Not enough nodes');
                    end
                end
            end
        %end
        
    end

end

