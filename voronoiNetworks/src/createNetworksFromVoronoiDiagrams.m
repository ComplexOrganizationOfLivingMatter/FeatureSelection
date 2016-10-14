function [ ] = createNetworksFromVoronoiDiagrams( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    dataFiles = getAllFiles('E:\Pablo\PhD-miscelanious\voronoiNetworks\data\voronoiDiagrams\');
    for numFile = 1:size(dataFiles,1)
        fullPathFile = dataFiles(numFile);
        fullPathFile = fullPathFile{:};
        diagramName = strsplit(fullPathFile, '\');
        diagramName = diagramName(end);
        diagramName = diagramName{1};

        %Check which files we want.
        if size(strfind(lower(diagramName), '.mat'), 1) >= 1
            load(fullPathFile);
            
            %celulas_validas = validCells
            validCellNeighbours = Vecinos(celulas_validas);
            adjacencyMatrix = zeros(size(Vecinos, 2));
            for numCell = 1:size(validCellNeighbours, 2)
                neighbours = validCellNeighbours(numCell);
                adjacencyMatrix(celulas_validas(numCell), neighbours{1}) = 1;
            end
            outputFile = strcat('results\networks\adjacencyMatrix', diagramName);
            save(outputFile, 'adjacencyMatrix');
            
            generateLEDAFromAdjacencyMatrix
        end
    end

end

