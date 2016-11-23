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
                outputDir = strjoin(outputDir(1:end-1), '\');
                if exist(outputDir, 'dir') ~= 7
                    mkdir(outputDir);
                end
            end
            outputFile = strcat(outputFile, imageNameReal(1:end-5), '.ndump2');
        else
            outputFile = strcat('results\graphletResultsFiltered\allOriginal\', imageNameReal(1:end-5), '.ndump2');
        end

        imageName;
        dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
        matrixToFilter = csvread(fullPathImage);
        dataFileName = allFilesData(dataFile);

        outputFileSplitted = strsplit(outputFile, '\');
        outputFileCancer = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\CancerCells\', imageNameReal(1:end-5), '_OnlyWeightedCells.ndump2');
        outputFileCancerNeighbours = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\NeighboursOfCancerCells\', imageNameReal(1:end-5), '_OnlyNeighboursOfWeightedCells.ndump2');

        if isempty(dataFileName) == 0
            load(dataFileName{1});

            if isempty(strfind(outputFile, 'Weighted')) == 0 && isequal(kindOfValidCells, 'finalValidCells')

                imageNameSplitted = strsplit(imageNameReal, '_');
                weightsFileName = strcat('data\', typeOfData, '\data\', imageNameSplitted{2}, '\', strjoin(imageNameSplitted(9:end-1), '_'), '\', strjoin(imageNameSplitted(3:end), '_'), '.mat');
                load(weightsFileName);
                weightedCells = find(wts>0); %Weighted cells
                neighbours = vertcat(vecinos{wts>0}); %and neighbours
                weightedValidCells = intersect(finalValidCells, weightedCells);
                neighboursValidCells = intersect(finalValidCells, setxor(weightedCells, neighbours)); %Only the neighbours without the weigthed
                matrixToFilter(:, removingGraphlets) = 0;
                outputDir = strsplit(outputFileCancer, '\');
                outputDir = strjoin(outputDir(1:end-1), '\');
                if exist(outputDir, 'dir') ~= 7
                    mkdir(outputDir);
                end

                if size(matrixToFilter(weightedValidCells), 1) > 6
                    if exist(outputFileCancer, 'file') ~= 2
                        dlmwrite(outputFileCancer, matrixToFilter(weightedValidCells, :), ' ');
                    end
                else
                    fullpathImage
                    disp('Not enough nodes');
                end

                if size(matrixToFilter(neighboursValidCells), 1) > 6
                    if exist(outputFileCancerNeighbours, 'file') ~= 2
                        dlmwrite(outputFileCancerNeighbours, matrixToFilter(neighboursValidCells), ' ');
                    end
                else
                    fullpathImage
                    disp('Not enough nodes');
                end
            end
            if exist(outputFile, 'file') ~= 2
                if isequal(kindOfValidCells, 'finalValidCells') == 0
                    if isempty(strfind(outputFile, 'weight')) == 0
                        outputFileSplitted = strsplit(outputFile, '\');
                        outputNeigboursFileSplitted = strsplit(neighboursPath, '\');
                        outputFile = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\', outputNeigboursFileSplitted{end-1} ,'\', imageNameReal(1:end-5), '.ndump2');

                        finalMatrixFiltered = matrixToFilter(finalValidCells, :);
                    else
                        finalMatrixFiltered = matrixToFilter(celulas_validas, :);
                    end
                else
                    matrixToFilter(:, removingGraphlets) = 0;
                    finalMatrixFiltered = matrixToFilter(finalValidCells, :);
                end

                if size(finalMatrixFiltered, 1) > 6
                    dlmwrite(outputFile, finalMatrixFiltered, ' ');
                else
                    fullPathImage
                    disp('Not enough nodes');
                end

            end
        end
    %             if isempty(strfind(outputFile, 'Atrophy')) == 0 && isequal(kindOfValidCells, 'finalValidCells')
    %                 outputFileSplitted = strsplit(outputFile, '\');
    %                 outputFileAtrophic = strcat(strjoin(outputFileSplitted(1:end-1), '\'), '\atrophicCells\' , outputFileSplitted{end});
    %
    %                 if exist(outputFileAtrophic, 'file') ~= 2
    %                     dataFile = cellfun(@(x) size(strfind(x, strrep(imageNameReal, '-', ' ')), 1) > 0, allFilesData);
    %                     matrixToFilter = csvread(fullPathImage);
    %                     dataFileName = allFilesData(dataFile);
    %                     load(dataFileName{1});
    %                     finalMatrixFiltered = matrixToFilter(unique(atrophicCells), :);
    %
    %                     if size(finalMatrixFiltered, 1) >= 6
    %                         finalMatrixFiltered(:, removingGraphlets) = 0;
    %                         dlmwrite(outputFileAtrophic, finalMatrixFiltered, ' ');
    %                     else
    %                         fullPathImage
    %                         disp('Not enough nodes');
    %                     end
    %                 end
    %             end
    %end

    end

end

