function [  ] = unifyDistances(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    comparisonFiles = getAllFiles('results\comparisons\EveryFile\maxLength5\');
    differenceWithRegularHexagon = [];
    namesFinal = {};
    for numFile = 1:size(comparisonFiles,1)
        fullPathImage = comparisonFiles(numFile);
        fullPathImage = fullPathImage{:};
        fullPathImageSplitted = strsplit(fullPathImage, '\');
        imageName = fullPathImageSplitted{end};

        if isequal(imageName, 'distanceMatrixGDDA.mat') && isempty(strfind(fullPathImage, 'AllAtrophy'))
            load(fullPathImage);
            differenceWithRegularHexagon = [differenceWithRegularHexagon, distanceMatrix(1, 2:end)];
            if isempty(namesFinal) == 0
                if size(namesFinal, 1) ~= size(names, 1)
                    names = names';
                end
                namesFinal = [namesFinal, names{2:end}];
            else
                if size(names, 2) == 1
                    names = names';
                end
                namesFinal = names(2:end);
            end
        end
    end

    save('results\comparisons\EveryFile\maxLength5\allDifferences.mat', 'differenceWithRegularHexagon', 'namesFinal');

end

