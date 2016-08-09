function [ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded] = findingEdgesBetweenLevels(voronoiClass, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise, classesToVisualize)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


    verticesVAdded = zeros(size(verticesV,1), 1);
    verticesVNoiseAdded = zeros(size(verticesVNoise, 1), 1);

    edgesBetweenLevels = [];

    classes = 1:max(voronoiClass(:));

    for class = 1:size(classes, 2)
        class
        %Get vertices of both classes
        %Firstly, we get the rows of the class, which will correspond with
        %its vertices.
        [verticesVoronoiOfClassRows, verticesVoronoiOfClassCols] = find(neighboursVerticesV(:,:) == class);
        centroidsOfVoronoiClass = verticesV(verticesVoronoiOfClassRows, :);
        
        [verticesVoronoiNoiseOfClassRows, verticesVoronoiNoiseOfClassCols] = find(neighboursVerticesVNoise(:,:) == class);
        centroidsOfVoronoiNoiseClass = verticesVNoise(verticesVoronoiNoiseOfClassRows, :);
        
        %In the case they don't match all the vertices of one class to the
        %other, one vertex (or more) should be linked to more than one
        %vertex.
        if size(centroidsOfVoronoiClass, 1) == size(centroidsOfVoronoiNoiseClass, 1) && size(centroidsOfVoronoiClass, 1) > 0
            if find(class == classesToVisualize, 1) > 0
                matching = getMinimumMatchingBetweenPolygons(centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass)
                edgesBetweenLevels = [edgesBetweenLevels; matching];
            end
        else
            if find(class == classesToVisualize, 1) > 0
                matching = getMinimumMatchingBetweenPolygons(centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass)
                edgesBetweenLevels = [edgesBetweenLevels; matching];
            end
%             %calculate distance between the current point and all near him.
%             distancePoints = pdist([centroidsOfVoronoiClass; centroidsOfVoronoiNoiseClass]);
%             %Square form
%             distancePoints = squareform(distancePoints);
%             %Don't want the points with themselves
%             %Don't want points within the same plane
%             distancePoints(1:size(centroidsOfVoronoiClass,1), 1:size(centroidsOfVoronoiClass,1)) = NaN;
%             rowsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));
%             colsAux = size(centroidsOfVoronoiClass,1)+1:(size(centroidsOfVoronoiClass,1) + size(centroidsOfVoronoiNoiseClass,1));
%             distancePoints(rowsAux, colsAux) = NaN;
%             
%             for vertex = 1:max(size(centroidsOfVoronoiClass,1), size(centroidsOfVoronoiNoiseClass,1))
%                 minimumDistance = min(distancePoints(:));
%                 [rowMin, colMin] = find(distancePoints == minimumDistance, 1);
%                 distancePoints(rowMin, colMin) = NaN;
%                 distancePoints(colMin, rowMin) = NaN;
%                 
%                 verticesVAdded(verticesVoronoiOfClassRows(min(rowMin, colMin))) = verticesVAdded(verticesVoronoiOfClassRows(min(rowMin, colMin))) + 1;
%                 verticesVNoiseAdded(verticesVoronoiNoiseOfClassRows(max(rowMin, colMin)-size(centroidsOfVoronoiClass,1))) = verticesVNoiseAdded(verticesVoronoiNoiseOfClassRows(max(rowMin, colMin)-size(centroidsOfVoronoiClass,1))) + 1;
%                 %add to the list of edges
%                 edgesBetweenLevels = [edgesBetweenLevels; centroidsOfVoronoiClass(min(rowMin, colMin), :), 2; centroidsOfVoronoiNoiseClass(max(rowMin, colMin)-size(centroidsOfVoronoiClass,1), :), 0];
%             end
%             edgesBetweenLevels;
        end
    end

end

