function [ minMatchingEdges ] = getMinimumMatchingBetweenPolygons( centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass )
%GETMINIMUMMATCHINGBETWEENPOLYGONS Summary of this function goes here
%   Detailed explanation goes here

    %calculate distance between the current point and all near him.
    distancePoints = pdist([centroidsOfVoronoiClass; centroidsOfVoronoiNoiseClass]);
    %Square matrix
    distancePoints = squareform(distancePoints);
    
    rowsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));
    
    %Don't want the points with themselves
    %Don't want points within the same plane
    distancePoints(1:size(centroidsOfVoronoiClass,1), 1:size(centroidsOfVoronoiClass,1)) = NaN;
    distancePoints(rowsAux(:), :) = NaN;
    
    verticesVoronoiAdded = zeros(size(centroidsOfVoronoiClass, 1) , 1);
    verticesNoiseAdded = zeros(size(centroidsOfVoronoiNoiseClass, 1), 1);
    minMatchingEdges = [];
    %Run until there's some vertex without a pair
    while min(verticesVoronoiAdded(:,:)) == 0 || min(verticesNoiseAdded(:,:)) == 0
        minValue = min(distancePoints(:));
        [rowMin, colMin] = find(distancePoints == minValue, 1);
        realCol = colMin - size(centroidsOfVoronoiClass, 1);
        centroidVClass = centroidsOfVoronoiClass(rowMin, :);
        centroidVNoiseClass = centroidsOfVoronoiNoiseClass(realCol, :);
        distancePoints(rowMin, colMin) = NaN;
        
        verticesVoronoiAdded(rowMin, 1) = verticesVoronoiAdded(rowMin, 1) + 1;
        verticesNoiseAdded(realCol, 1) = verticesNoiseAdded(realCol, 1) + 1;
        
        minMatchingEdges = [minMatchingEdges; centroidVClass, 6; centroidVNoiseClass, 0];
    end
    
    %Check if there's useless edges (i.e. linking 2 centroids on each plane
    % several times).
    
    %Pedro's proposal
    p0EdgesUnique = unique(minMatchingEdges(minMatchingEdges(:, 3) == 0, :), 'rows');
    p2EdgesUnique = unique(minMatchingEdges(minMatchingEdges(:, 3) == 6, :), 'rows');
    totalEdges = size(minMatchingEdges, 1);
    
    
    if totalEdges/2 > max(size(centroidsOfVoronoiClass, 1), size(centroidsOfVoronoiNoiseClass, 1))
        duplicatedEdges = [];
        edge = 1;
        while edge <= totalEdges
            edge
            minMatchingEdgesAux = minMatchingEdges;
            minMatchingEdgesAux([edge, edge + 1], :) = [];
            %No vertices removed
            if sum(ismember(p0EdgesUnique, minMatchingEdgesAux, 'rows') == 0) == 0 && sum(ismember(p2EdgesUnique, minMatchingEdgesAux, 'rows') == 0) == 0
                duplicatedEdges = [duplicatedEdges; edge];
            end
            
            edge = edge + 2;
        end
        
        if(size(duplicatedEdges, 1) > 0)
            minDistancesEdges = {};
            minDistances = [];
            maxCombinationsEdges = 2*max(size(centroidsOfVoronoiNoiseClass, 1), size(centroidsOfVoronoiClass, 1));
            maxCombinations = min(size(duplicatedEdges, 1), maxCombinationsEdges);
            minCombinations = abs(size(duplicatedEdges, 1) - maxCombinations) + 1;
            for i = minCombinations:size(duplicatedEdges, 1)
                combinationsEdges = nchoosek(duplicatedEdges,i);
                for combEdge = 1:size(combinationsEdges, 1)
                    minMatchingEdgesAux = minMatchingEdges;
                    minMatchingEdgesAux([combinationsEdges(combEdge, :), combinationsEdges(combEdge,:)+1], :) = [];
                    if sum(ismember(p0EdgesUnique, minMatchingEdgesAux, 'rows') == 0) == 0 && sum(ismember(p2EdgesUnique, minMatchingEdgesAux, 'rows') == 0) == 0
                        distances = distancesBetweenEdges(minMatchingEdgesAux);
                        minDistance = sum(distances);
                        minDistancesEdges{end+1} = minMatchingEdgesAux;
                        minDistances = [minDistances; minDistance];
                    end
                end
            end
            numMinimum = find(minDistances == min(minDistances));
            minMatchingEdges = minDistancesEdges{numMinimum};
        end
        
    end    
end

