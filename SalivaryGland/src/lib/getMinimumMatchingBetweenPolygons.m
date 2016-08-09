function [ minMatchingEdges ] = getMinimumMatchingBetweenPolygons( centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
    %calculate distance between the current point and all near him.
    distancePoints = pdist([centroidsOfVoronoiClass; centroidsOfVoronoiNoiseClass]);
    %Square form
    distancePoints = squareform(distancePoints);
    %Don't want the points with themselves
    %Don't want points within the same plane
    
    rowsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));  
    distancePoints(1:size(centroidsOfVoronoiClass,1), 1:size(centroidsOfVoronoiClass,1)) = NaN;
    distancePoints(rowsAux(:), :) = NaN;
    
    verticesVoronoiAdded = zeros(size(centroidsOfVoronoiClass, 1) , 1);
    verticesNoiseAdded = zeros(size(centroidsOfVoronoiNoiseClass, 1), 1);
    minMatchingEdges = [];
    while min(verticesVoronoiAdded(:,:)) == 0 || min(verticesNoiseAdded(:,:)) == 0
        minValue = min(distancePoints(:));
        [rowMin, colMin] = find(distancePoints == minValue, 1);
        realCol = colMin - size(centroidsOfVoronoiClass, 1);
        centroidVClass = centroidsOfVoronoiClass(rowMin, :);
        centroidVNoiseClass = centroidsOfVoronoiNoiseClass(realCol, :);
        distancePoints(rowMin, colMin) = NaN;
        
        verticesVoronoiAdded(rowMin, 1) = verticesVoronoiAdded(rowMin, 1) + 1;
        verticesNoiseAdded(realCol, 1) = verticesNoiseAdded(realCol, 1) + 1;
        
        minMatchingEdges = [minMatchingEdges; centroidVClass, 2; centroidVNoiseClass, 0]
    end
    
    %Check if there's useless edges (i.e. linking 2 centroids on each plane
    % several times).
    
%     totalEdges = size(minMatchingEdges, 1);
%     distances = zeros(totalEdges/2, 1);
%     i = 1;
%     while i <= totalEdges
%        distances((i+1)/2) = sqrt((minMatchingEdges(i, 1) - minMatchingEdges(i+1, 1))^2 + (minMatchingEdges(i, 2) - minMatchingEdges(i+1, 2))^2);
%         i = i + 2;
%     end
%     
%     while distances(isnan(distances(:)) == 0) > 0
%         maxDistance = max(distances(:));
%         edge = find(maxDistance == distances, 1);
%         distances(edge) = [];
%         edge = edge*2 - 1;
%         duplicateEdges = [];
%         %If it's the upper plane, we get the edge of the lower one
%         if mod(edge, 2) == 1
%             duplicateEdges = find(minMatchingEdges(edge, 1) == minMatchingEdges(:, 1) & minMatchingEdges(edge, 2) == minMatchingEdges(:, 2) & minMatchingEdges(edge, 3) == minMatchingEdges(:, 3));
%             duplicateEdges(:) = duplicateEdges(:) + 1;
%         end
%         if size(duplicateEdges, 1) > 1
%             for duplicate = 1:size(duplicateEdges, 1)
%                 consultingEdge = find(minMatchingEdges(duplicateEdges(duplicate), 1) == minMatchingEdges(:, 1) & minMatchingEdges(duplicateEdges(duplicate), 2) == minMatchingEdges(:, 2) & minMatchingEdges(duplicateEdges(duplicate), 3) == minMatchingEdges(:, 3));
%                 if size(consultingEdge, 1) > 1 %there's a cycle, remove the edge between the duplicates
%                     %We only want real edges to erase
%                     if duplicateEdges(duplicate) == edge + 1
%                         edge
%                         duplicateEdges(duplicate)
%                         
%                         minMatchingEdges([edge; duplicateEdges(duplicate)], :) = [];
%                         break
%                     end
%                 end
%             end
%         end
%     end
    
    
    %Pedro's proposal
      
    
end

