function [ minMatchingEdges ] = getMinimumMatchingBetweenPolygons( centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass )
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
    %Combinations of edges
    for i = 1:size(combinations, 1); 
        combinationsAux = combinations;
        combinationActual = zeros(size(centroidsOfVoronoiClass, 1), 2);
        numCombinations = 1;
        row = i;
        while numCombinations <= size(centroidsOfVoronoiClass, 1)
           if combinationsAux(row, 1) ~= -1 && combinationsAux(row, 2) ~= -1
               combinationActual(numCombinations, 1) = combinationsAux(row, 1);
               combinationActual(numCombinations, 2) = combinationsAux(row, 2) + size(centroidsOfVoronoiClass, 1);
               combinationsAux(combinationsAux(:, 1) == combinationsAux(row, 1)) = -1;
               combinationsAux(combinationsAux(:, 2) == combinationsAux(row, 2)) = -1;
               numCombinations = numCombinations + 1;
           end
            row = row + 1;
            if row > size(combinationsAux, 1)
               row = 1; 
            end
        end
        edgesCombinations{end+1} = combinationActual;
    end
    
    %Get the minimal combination
    minMatchingDistance = intmax('int32');
    for edgesCombination = 1:size(edgesCombinations, 2)
       combActual = edgesCombinations{edgesCombination};
       distances = distancePoints(combActual(:, 1), combActual(:, 2));
       %The diag are the correct values
       distanceActual = sum(diag(distances));
       
       if distanceActual < minMatchingDistance
           %Conversion of centroids to the correct ones
           combActual(:, 2) = combActual(:, 2) - size(centroidsOfVoronoiClass, 1);
           minMatchingEdges = zeros(size(combActual, 1)*2, 3);
           for i = 1:size(combActual, 1)
               minMatchingEdges = [minMatchingEdges; centroidsOfVoronoiClass(combActual(i, 1), :), 2; centroidsOfVoronoiNoiseClass(combActual(i, 2), :), 0];
           end
           minMatchingDistance = distanceActual
       end
    end
end

