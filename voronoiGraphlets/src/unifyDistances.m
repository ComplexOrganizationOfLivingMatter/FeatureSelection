function [  ] = unifyDistances( path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    comparisonFiles = getAllFiles(path);
    differenceWithRegularHexagon = [];
    namesFinal = {};
    for numFile = 1:size(comparisonFiles,1)
        fullPathImage = comparisonFiles(numFile);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted{end};

        if isempty(strfind(imageName, 'distanceMatrix')) == 0 && isempty(strfind(fullPathImage, 'AtrophicCells')) %&& isempty(strfind(fullPathImage, '\CancerCells'))
            load(fullPathImage);
            if isempty(strfind(fullPathImage, 'AgainstVoronoi1')) == 0
                differenceWithRegularHexagon = [differenceWithRegularHexagon, differenceMean'];
            else
                differenceWithRegularHexagon = [differenceWithRegularHexagon, distanceMatrix(1, 2:end)];
            end
            if isempty(namesFinal) == 0
                if size(namesFinal, 1) ~= size(names, 1)
                    names = names';
                end
                
                if isempty(strfind(fullPathImage, 'AgainstVoronoi1'))
                    namesFinal = [namesFinal, names{2:end}];
                else
                    namesFinal = [namesFinal, names{:}];
                end
            else
                if size(names, 2) == 1
                    names = names';
                end
                if isempty(strfind(fullPathImage, 'AgainstVoronoi1'))
                     namesFinal = names(2:end);
                else
                     namesFinal = names;
                end
            end
        end
    end

    save(strcat(path, 'allDifferences.mat'), 'differenceWithRegularHexagon', 'namesFinal');

end

