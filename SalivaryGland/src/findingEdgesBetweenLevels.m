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
        %Firstly, we get the rows of the class, which will correspond with
        %its vertices.
        [verticesVoronoiOfClassRows, verticesVoronoiOfClassCols] = find(neighboursVerticesV(:,:) == class)
        centroidsOfVoronoiClass = verticesV(verticesVoronoiOfClassRows, :);
        
        [verticesVoronoiNoiseOfClassRows, verticesVoronoiNoiseOfClassCols] = find(neighboursVerticesVNoise(:,:) == class)
        centroidsOfVoronoiNoiseClass = verticesV(verticesVoronoiNoiseOfClassRows, :);
        
        %In the case they don't match all the vertices of one class to the
        %other, one vertex (or more) should be linked to more than one
        %vertex.
        if size(centroidsOfVoronoiClass, 1) == size(centroidsOfVoronoiNoiseClass, 1)
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
            
            for vertex = 1:size(centroidsOfVoronoiClass,1)
                minimumDistance = min(distancePoints(:));
                [rowMin, colMin] = find(distancePoints == minimumDistance, 1);
                distancePoints(rowMin, :) = NaN;
                distancePoints(colMin, :) = NaN;
                distancePoints(:, rowMin) = NaN;
                distancePoints(:, colMin) = NaN;
                %add to the list of edges
                edgesBetweenLevels = [edgesBetweenLevels; centroidsOfVoronoiClass(min(rowMin, colMin), :), 2; centroidsOfVoronoiNoiseClass(max(rowMin, colMin)-size(centroidsOfVoronoiClass,1), :), 0];
            end
            edgesBetweenLevels
        else
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
            
            for vertex = 1:max(size(centroidsOfVoronoiClass,1), size(centroidsOfVoronoiNoiseClass,1))
                minimumDistance = min(distancePoints(:));
                [rowMin, colMin] = find(distancePoints == minimumDistance, 1);
                distancePoints(rowMin, colMin) = NaN;
                distancePoints(colMin, rowMin) = NaN;
                %add to the list of edges
                edgesBetweenLevels = [edgesBetweenLevels; centroidsOfVoronoiClass(min(rowMin, colMin), :), 2; centroidsOfVoronoiNoiseClass(max(rowMin, colMin)-size(centroidsOfVoronoiClass,1), :), 0];
            end
            edgesBetweenLevels
        end
    end

end

