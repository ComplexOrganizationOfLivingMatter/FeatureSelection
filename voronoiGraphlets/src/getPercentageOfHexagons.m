function [  ] = getPercentageOfHexagons( currentPath )
%GETPERCENTAGEOFHEXAGONS Get the percentage of hexagons of a tesselation.
%   Calculate the number of nodes surrounded by 6 neighbours.
%   This number will be divided by the total number of nodes, 
%   giving the percentage.
%   From this purpose we only want the first column of
%   each row. If it is a 6, then we add it.
%
%   currentPath: where the information is.
%
%   Developed by Pablo Vicente-Munuera
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

    percentageOfHexagons;
    nameFiles;

    save('percentageOfHexagons.mat', 'percentageOfHexagons', 'nameFiles');

end

