function [ ] = createNetworksFromVoronoiDiagrams(currentPath, outputPath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    dataFiles = getAllFiles(currentPath);
    for numFile = 1:size(dataFiles,1)
        fullPathFile = dataFiles(numFile);
        fullPathFile = fullPathFile{:};
        diagramName = strsplit(fullPathFile, '\');
        diagramName = diagramName(end);
        diagramName = diagramName{1};

        %Check which files we want.
        if isempty(strfind(lower(diagramName), '.mat')) == 0
            fullPathFile
            load(fullPathFile);
            outputFile = strcat(outputPath, 'adjacencyMatrix', diagramName);
            if exist(outputFile, 'file') ~= 2
            
                %celulas_validas = validCells
                validCellNeighbours = vecinos(celulas_validas');
                adjacencyMatrix = zeros(size(vecinos, 2));
                for numCell = 1:size(validCellNeighbours, 2)
                    neighbours = validCellNeighbours(numCell);
                    adjacencyMatrix(celulas_validas(numCell), neighbours{1}) = 1;
                end

                save(outputFile, 'adjacencyMatrix');
            end
        end
    end

end

