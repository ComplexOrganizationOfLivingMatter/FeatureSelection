function [  ] = getPercentageOfHexagons( currentPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    totalGraphlets = getAllFiles(currentPath);

    percentageOfHexagons = [];
    nameFiles = {};
    for numFile = 1:size(totalGraphlets, 1)
        fullPathFile = totalGraphlets(numFile);
        fullPathFile = fullPathFile{:};
        diagramName = strsplit(fullPathFile, '\');
        diagramName = diagramName(end);
        diagramName = diagramName{1};

        %Check which files we want.
        if isempty(strfind(lower(diagramName), '.ndump2')) == 0
            matrixGraphlets = csvread(fullPathFile);
            percentageOfHexagons(end+1) = sum(matrixGraphlets(:, 1) == 6) / size(matrixGraphlets, 1)*100;
            nameFiles{end+1} = fullPathFile;
        end


    end

    percentageOfHexagons
    nameFiles

    save('percentageOfHexagons.mat', 'percentageOfHexagons', 'nameFiles');

end

