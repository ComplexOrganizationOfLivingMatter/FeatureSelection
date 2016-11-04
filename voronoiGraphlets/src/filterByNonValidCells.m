function [ ] = filterByNonValidCells( currentPath, neighboursPath, kindOfValidCells)
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
        
        if isequal(kindOfValidCells, 'finalValidCells')
            outputFile = strrep(neighboursPath, 'validCellsMaxPathLength', 'graphletResultsFiltered');
            outputFile = strcat(outputFile, imageNameReal(1:end-5), '.ndump2');
        else
            outputFile = strcat('results\graphletResultsFiltered\allOriginal\', imageNameReal(1:end-5), '.ndump2');
        end
        if isempty(strfind(outputFile, 'Weighted')) == 0
            outputFileCancer = strrep(neighboursPath, 'validCellsMaxPathLength', 'graphletResultsFiltered');
            outputFileCancer = strcat(outputFileCancer, 'CancerCellsAndNeighbours\', imageNameReal(1:end-5), '_OnlyWeightedCellsAndNeighbours.ndump2');
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
                weightedCellsAndNeighbours = union(vertcat(vecinos{wts>0}), find(wts>0)); %and neighbours
                weightedAndNeighboursValidCells = intersect(finalValidCells, weightedCellsAndNeighbours);
                finalMatrixFiltered = matrixToFilter(weightedAndNeighboursValidCells, :); 

                if size(finalMatrixFiltered, 1) > 6
                    dlmwrite(outputFileCancer, finalMatrixFiltered, ' ');
                else
                    fullpathImage
                    disp('Not enough nodes');
                end
            end
        end
        if exist(outputFile, 'file') ~= 2
            dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
            matrixToFilter = csvread(fullPathImage);
            dataFileName = allFilesData(dataFile);
            load(dataFileName{1});
            
            if isequal(kindOfValidCells, 'finalValidCells')
                finalMatrixFiltered = matrixToFilter(finalValidCells, :);
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
    end

end

