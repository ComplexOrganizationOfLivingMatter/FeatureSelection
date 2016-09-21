function [ minMatchingEdges ] = getMinimumMatchingBetweenPolygons( centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass )
%GETMINIMUMMATCHINGBETWEENPOLYGONS Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

    %calculate distance between the current point and all near him.
    distancePoints = pdist([centroidsOfVoronoiClass; centroidsOfVoronoiNoiseClass]);
    %Square matrix
    distancePoints = squareform(distancePoints);
    
    rowsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));
    
    %Don't want the points with themselves
    %Don't want points within the same plane
    distancePoints(1:size(centroidsOfVoronoiClass,1), 1:size(centroidsOfVoronoiClass,1)) = NaN;
    distancePoints(rowsAux(:), :) = NaN;
    distancePointsAux = distancePoints;
    
    verticesVoronoiAdded = zeros(size(centroidsOfVoronoiClass, 1) , 1);
    verticesNoiseAdded = zeros(size(centroidsOfVoronoiNoiseClass, 1), 1);
    minMatchingEdges = [];
    %Run until there's some vertex without a pair
    numVertex = 1;
    while numVertex <= (size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1))
        if numVertex <= size(centroidsOfVoronoiClass,1)
            minValue = min(distancePoints(numVertex, :));
            [rowMin, colMin] = find(distancePoints(numVertex, :) == minValue, 1);
            rowMin = numVertex;
        else
            minValue = min(distancePoints(:, numVertex));
            [rowMin, colMin] = find(distancePoints(:, numVertex) == minValue, 1);
            colMin = numVertex;
        end
        
        realCol = colMin - size(centroidsOfVoronoiClass, 1);
        centroidVClass = centroidsOfVoronoiClass(rowMin, :);
        centroidVNoiseClass = centroidsOfVoronoiNoiseClass(realCol, :);
        
        if isnan(distancePointsAux(rowMin, colMin)) == 0
            verticesVoronoiAdded(rowMin, 1) = verticesVoronoiAdded(rowMin, 1) + 1;
            verticesNoiseAdded(realCol, 1) = verticesNoiseAdded(realCol, 1) + 1;

            minMatchingEdges = [minMatchingEdges; centroidVClass, 6; centroidVNoiseClass, 0];
            distancePointsAux(rowMin, colMin) = NaN;
            distancePointsAux(colMin, rowMin) = NaN;
        end
        numVertex = numVertex + 1;
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
            minMatchingEdgesAux = minMatchingEdges;
            minMatchingEdgesAux([edge, edge + 1], :) = [];
            %No vertices removed
            if sum(ismember(p0EdgesUnique, minMatchingEdgesAux, 'rows') == 0) == 0 && sum(ismember(p2EdgesUnique, minMatchingEdgesAux, 'rows') == 0) == 0
                duplicatedEdges = [duplicatedEdges; edge];
            end
            
            edge = edge + 2;
        end
        (edge + 1)/2
        
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
            size(minMatchingEdges, 1)/2
            minMatchingEdges = minDistancesEdges{numMinimum};
            size(minMatchingEdges, 1)/2
        end
        
    end    
end

