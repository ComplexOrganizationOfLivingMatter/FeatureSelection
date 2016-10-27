function [ finalValidCells ] = getValidCellsFromROI(currentPath, maxPathLength)
%UNTITLED Summary of this function goes here
%   We get the valid cells with no valid cells in all the paths 
%   of a max length (maxPathLength)
%
%   Developed by Pablo Vicente-Munuera

    dataFiles = getAllFiles(currentPath);
    for numFile = 1:size(dataFiles,1)
        fullPathFile = dataFiles(numFile);
        fullPathFile = fullPathFile{:};
        diagramNameSplitted = strsplit(fullPathFile, '\');
        diagramName = diagramNameSplitted(end);
        diagramName = diagramName{1};

        typeName = diagramNameSplitted(end - 2);
        typeName = typeName{1};
        outputFile = strcat('results\validCellsMaxPathLength\voronoiWeighted\maxLength', num2str(maxPathLength), '_', typeName ,'_', diagramName);
        %Check which files we want.
        if size(strfind(lower(diagramName), '.mat'), 1) >= 1 && exist(outputFile, 'file') ~= 2
            fullPathFile
            load(fullPathFile);%load valid cells and neighbours
            
            if exist('vecinos', 'var') == 1
                neighbours = vecinos;
            elseif exist('Vecinos', 'var') == 1
                neighbours = Vecinos;
            else
                error('No neighbours variable');
            end
            validCells = celulas_validas;
            maxCellLabel = max(cellfun(@(x) max(x), neighbours));
            noValidCells = setxor(1:maxCellLabel, validCells);

            if size(neighbours, 2) ~= (size(noValidCells, 2) + size(validCells, 2))
                error('Incorrect number of no valid cells'); 
            end

            finalValidCells = [];
            for numCell = 1:size(neighbours, 2)
                neighboursInMaxPathLength = [];
                antNeighbours = [neighbours{numCell}];
                noValidCellsInPath = intersect(noValidCells, antNeighbours);
                neighboursInMaxPathLength = unique(horzcat(neighboursInMaxPathLength, antNeighbours'));

                if isempty(noValidCellsInPath) == 0
                    continue %it is a no valid cell
                end
                pathLengthActual = 3;
                while pathLengthActual <= maxPathLength
                    actualNeighbours = vertcat(neighbours{antNeighbours});
                    neighboursInMaxPathLength = unique(horzcat(neighboursInMaxPathLength, actualNeighbours'));
                    antNeighbours = actualNeighbours;
                    pathLengthActual = pathLengthActual + 1;
                end

                noValidCellsInPath = intersect(noValidCells, neighboursInMaxPathLength);
                if isempty(noValidCellsInPath)
                    finalValidCells(end+1) = numCell;
                end
            end
            
            vecinos = neighbours;
            celulas_validas = validCells;
            save(outputFile, 'finalValidCells', 'celulas_validas', 'vecinos');
        end
    end
end

