function [ edgesCombinations ] = getMinimumMatchingBetweenPolygons( centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    %calculate distance between the current point and all near him.
    distancePoints = pdist([centroidsOfVoronoiClass; centroidsOfVoronoiNoiseClass]);
    %Square form
    distancePoints = squareform(distancePoints);
    %Don't want the points with themselves
    %Don't want points within the same plane
    distancePoints(1:size(centroidsOfVoronoiClass,1), 1:size(centroidsOfVoronoiClass,1)) = NaN;
    rowsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));
    colsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));
    distancePoints(rowsAux, colsAux) = NaN;
    
    combinations = fullfact([size(centroidsOfVoronoiClass, 1), size(centroidsOfVoronoiClass, 1)]);
    edgesCombinations = {};
    for i = 1:size(combinations, 1); 
        combinationsAux = combinations;
        combinationActual = zeros(size(centroidsOfVoronoiClass, 1), 2);
        numCombinations = 1;
        row = i;
        mid = 0;
        while numCombinations < size(centroidsOfVoronoiClass, 1)
            if sum(combinationsAux(row, :) == -1) == 0
               if combinationsAux(row, 1) == numCombinations || combinationsAux(row, 2) == numCombinations
                   combinationActual(numCombinations, :) = combinationsAux(row, :);
                   combinationsAux(combinationsAux(:, 1) == combinationsAux(row, 1)) = -1;
                   combinationsAux(combinationsAux(:, 2) == combinationsAux(row, 2)) = -1;
                   numCombinations = numCombinations + 1;
%                    if combinationsAux(row, 1) == combinationsAux(row, 2) && mid == 0
%                        numCombinations = numCombinations + 1;
%                    else
%                        if mid == 1
%                            mid = 0;
%                            numCombinations = numCombinations + 1;
%                        else
%                           mid = 1; 
%                        end
%                    end
               end
            end
            row = row + 1;
            if row > size(combinationsAux, 1)
               row = 1; 
            end
        end
        edgesCombinations{end+1} = combinationActual;
    end
    
    
    distancePointsAux = distancePoints;

end

