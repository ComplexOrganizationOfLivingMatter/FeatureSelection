function [ finalValidCells ] = getValidCellsFromROI(currentPath, maxPathLength, outputPath)
%GETVALIDCELLSFROMROI Get valid cells' in a given range (4 or 5)
%   We get the valid cells with no valid cells in all the paths 
%   of a max length (maxPathLength)
%
%   currentPath: actual path
%   maxPathLenth: the max length of the path where you won't find
%   no valid cells.
%   outputPath: path of the output
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
        if isempty(strfind(diagramName, typeName))
            outputFile = strcat(outputPath, 'maxLength', num2str(maxPathLength), '\', 'maxLength', num2str(maxPathLength), '_', typeName ,'_', diagramName);
        else
            outputFile = strcat(outputPath, 'maxLength', num2str(maxPathLength), '\', 'maxLength', num2str(maxPathLength) ,'_', diagramName);
        end
        %Check which files we want.
        if isempty(strfind(lower(diagramName), '.mat')) == 0 && exist(outputFile, 'file') ~= 2
            fullPathFile
            clear vecinos Vecinos celulas_validas
            load(fullPathFile);%load valid cells and neighbours
            
            if exist('vecinos', 'var') == 1
                neighbours = vecinos;
                clear vecinos
            elseif exist('Vecinos', 'var') == 1
                neighbours = Vecinos;
                clear Vecinos
            else
                error('No neighbours variable');
            end
            validCells = celulas_validas;
            clear celulas_validas
            neighboursEmpty = cellfun(@(x) isempty(x), neighbours);
            maxCellLabel = max(cellfun(@(x) max(x), neighbours(neighboursEmpty == 0)));
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
            clear vecinos celulas_validas
        end
    end
end

