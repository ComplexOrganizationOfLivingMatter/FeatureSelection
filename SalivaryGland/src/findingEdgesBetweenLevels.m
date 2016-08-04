function [ output_args ] = findingEdgesBetweenLevels( input_args )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

verticesVAdded = zeros(size(verticesV,1), 1);
verticesVNoiseAdded = zeros(size(verticesVNoise, 1), 1);

edgesBetweenLevels = [];
maxDistance = size(voronoiClass, 1)/(max(voronoiClass(:))/20);

for i = 1:size(verticesV, 1)
    xMin = verticesV(i, 1) - maxDistance;
    xMax = verticesV(i, 1) + maxDistance;
    
    yMin = verticesV(i, 2) - maxDistance;
    yMax = verticesV(i, 2) + maxDistance;
    
    %Filtered zone
    vNoiseFilteredX = verticesVNoise(verticesVNoise(:,1)> xMin & verticesVNoise(:,1) < xMax, :);
    vNoiseFilteredXY = vNoiseFilteredX(vNoiseFilteredX(:,2) > yMin & vNoiseFilteredX(:, 2) < yMax, :);
    
    if size(vNoiseFilteredXY, 1) > 0
        %calculate distance between the current point and all near him.
        distancePointNoiseRegion = pdist([verticesV(i,:); vNoiseFilteredXY]);
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
            cornerPoints = vNoiseFilteredXY(cornerNumberInZone, :);
            %Find the number of corner within the noise voronoi and all the area
            numberOfCornerNoise = find(verticesVNoise(:,1) == cornerPoints(:,1) & verticesVNoise(:,2) == cornerPoints(:,2));
            %Mark the vertices with them number of edges
            verticesVAdded(i) = verticesVAdded(i) + 1;
            verticesVNoiseAdded(numberOfCornerNoise) = verticesVNoiseAdded(numberOfCornerNoise) + 1;

            %the even will be points in the interior (voronoi noise) level and the
            %%odd cells will be point in the exterior (voronoi) level.
            edgesBetweenLevels = [edgesBetweenLevels; verticesV(i,:), 2; cornerPoints, 0];
        end
    end
end

end

