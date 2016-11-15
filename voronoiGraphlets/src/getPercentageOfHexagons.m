function [  ] = getPercentageOfHexagons( currentPath, maxLengthStr )
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
    percentageOfTriangles = [];
    percentageOfSquares = [];
    percentageOfHeptagons = [];
    percentageOfPentagons = [];
    percentageOfOctogons = [];
    percentageOfNonagons = [];
    percentageOfDecagons = [];
    
    nameFiles = {};
    for numFile = 1:size(totalGraphlets, 1)
        fullPathFile = totalGraphlets(numFile);
        fullPathFile = fullPathFile{:};
        diagramNameSplitted = strsplit(fullPathFile, '\');
        diagramName = diagramNameSplitted(end);
        diagramName = diagramName{1};

        %Check which files we want.
        if isempty(strfind(lower(diagramName), '.ndump2')) == 0 && isempty(strfind(lower(diagramNameSplitted{end-1}), 'atrophicCells')) && isempty(strfind(lower(diagramNameSplitted{end-1}), 'Cancer'))
            if isempty(strfind(lower(diagramNameSplitted{4}), lower(maxLengthStr))) == 0 || isempty(maxLengthStr)
                matrixGraphlets = csvread(fullPathFile);

                percentageOfTriangles(end+1) = sum(matrixGraphlets(:, 1) == 3) / size(matrixGraphlets, 1)*100;
                percentageOfSquares(end+1) = sum(matrixGraphlets(:, 1) == 4) / size(matrixGraphlets, 1)*100;
                percentageOfPentagons(end+1) = sum(matrixGraphlets(:, 1) == 5) / size(matrixGraphlets, 1)*100;
                percentageOfHexagons(end+1) = sum(matrixGraphlets(:, 1) == 6) / size(matrixGraphlets, 1)*100;
                percentageOfHeptagons(end+1) = sum(matrixGraphlets(:, 1) == 7) / size(matrixGraphlets, 1)*100;
                percentageOfOctogons(end+1) = sum(matrixGraphlets(:, 1) == 8) / size(matrixGraphlets, 1)*100;
                percentageOfNonagons(end+1) = sum(matrixGraphlets(:, 1) == 9) / size(matrixGraphlets, 1)*100;
                percentageOfDecagons(end+1) = sum(matrixGraphlets(:, 1) == 10) / size(matrixGraphlets, 1)*100;
                nameFiles{end+1} = fullPathFile;
            end
        end
    end
    %missing:  
    characteristicsCVT = [percentageOfTriangles; percentageOfSquares; percentageOfPentagons; percentageOfHexagons; percentageOfHeptagons; percentageOfOctogons; percentageOfNonagons; percentageOfDecagons]';
    distanceMatrix = squareform(pdist(characteristicsCVT));
%     points = mdscale(distanceMatrix, 2);
%     
%     nameFilesSplitted = cellfun(@(x) strsplit(x, '_'), nameFiles, 'UniformOutput', false);
%     nameFilesFinal = cellfun(@(x) x(5), nameFilesSplitted);
%     filter15 = cellfun(@(x) isequal(x, '015'), nameFilesFinal);
%     figure; plot(points(:, 1), points(:, 2), 'o');
%     t1 = text(points(filter15, 1), points(filter15, 2), nameFilesFinal(filter15), 'FontSize', 5, 'HorizontalAlignment', 'center');
%     percentageOfHexagons;
%     nameFiles;
    %points1Dimension = mdscale(distanceMatrix, 1, 'Criterion', 'sstress');
    save(strcat('results\comparisons\EveryFile\polygonDistributionDistanceMatrix', maxLengthStr ,'.mat'), 'distanceMatrix', 'nameFiles');
    save(strcat('results\comparisons\EveryFile\percentageOfHexagons', maxLengthStr, '.mat'), 'percentageOfHexagons', 'nameFiles');

end

