function [ edgesBetweenLevels ] = findingEdgesBetweenLevels(voronoiClass, voronoiNoise)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    [verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass);
    [verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise);

    verticesVAdded = zeros(size(verticesV,1), 1);
    verticesVNoiseAdded = zeros(size(verticesVNoise, 1), 1);

    edgesBetweenLevels = [];

    classes = 1:max(voronoiClass(:));

    for class = 1:size(classes, 2)
        %Get vertices of both classes
        verticesVoronoiOfClass = neighboursVerticesV(neighboursVerticesV(:,:) == class);


            %calculate distance between the current point and all near him.
            distancePointNoiseRegion = pdist([verticesV(class,:); vNoiseFiltered]);
            %Square form
            distancePointNoiseRegion = squareform(distancePointNoiseRegion);
            %We only want the distances related with our point
            distances = distancePointNoiseRegion(1,:);
            %Get the minimum distance
            minimumDistance = min(distances(2:end));
            %The number of corner (-1 because we added the first point)
            cornerNumberInZone = find(distances == minimumDistance, 1) - 1;
            if cornerNumberInZone ~= 0
                %Corner points
                cornerPoints = vNoiseFiltered(cornerNumberInZone, :);
                %Find the number of corner within the noise voronoi and all the area
                numberOfCornerNoise = find(verticesVNoise(:,1) == cornerPoints(:,1) & verticesVNoise(:,2) == cornerPoints(:,2));
                %Mark the vertices with them number of edges
                verticesVAdded(class) = verticesVAdded(class) + 1;
                verticesVNoiseAdded(numberOfCornerNoise) = verticesVNoiseAdded(numberOfCornerNoise) + 1;

                %the even will be points in the interior (voronoi noise) level and the
                %%odd cells will be point in the exterior (voronoi) level.
                edgesBetweenLevels = [edgesBetweenLevels; verticesV(class,:), 2; cornerPoints, 0];
            end
    end

end

