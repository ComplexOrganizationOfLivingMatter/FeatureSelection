function [ ] = createNetworksFromVoronoiDiagrams( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    dataFiles = getAllFiles('data\voronoiDiagrams\');
    for numFile = 1:size(dataFiles,1)
        fullPathFile = dataFiles(numFile);
        fullPathFile = fullPathFile{:};
        diagramName = strsplit(fullPathFile, '\');
        diagramName = diagramName(10);

        %Check which files we want.
        if size(strfind(lower(diagramName), '.mat'), 1) >= 1
            load(fullPathFile);

            validCellNeighbours = Vecinos(celulas_validas);
            adjacencyMatrix = zeros(size(validCellNeighbours, 2));
            for numCell = 1:size(validCellNeighbours, 2)
                adjacencyMatrix(numCell, validCellNeighbours(numCell)) = 1;
            end
            outputFile = strcat('results\networks\adjacencyMatrix', diagramName);
            save(outputFile, 'adjacencyMatrix');
        end
    end

end

