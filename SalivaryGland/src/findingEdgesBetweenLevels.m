function [ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded] = findingEdgesBetweenLevels(voronoiClass, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise, classesToVisualize, borderCells)
%FINDINGEDGESBETWEENLEVELS Summary of this function goes here
%   Detailed explanation goes here

    %FinalPixel of the x axis
    endPixelX = round(9*size(voronoiClass, 2)/12);
    %Initial Pixel of the x axis
    initPixelX = round(3*size(voronoiClass, 2)/12);
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
        
        if ismember(class, borderCells)
            centroidsOfVoronoiClass = centroidsOfVoronoiClass(centroidsOfVoronoiClass(:, 2) > initPixelX & centroidsOfVoronoiClass(:, 2) <= endPixelX, :);
            centroidsOfVoronoiNoiseClass = centroidsOfVoronoiNoiseClass(centroidsOfVoronoiNoiseClass(:, 2) > initPixelX & centroidsOfVoronoiNoiseClass(:, 2) <= endPixelX, :);
        else
            centroidsOfVoronoiClass = centroidsOfVoronoiClass(centroidsOfVoronoiClass(:, 2) > 512 & centroidsOfVoronoiClass(:, 2) <= 1024, :);
            centroidsOfVoronoiNoiseClass = centroidsOfVoronoiNoiseClass(centroidsOfVoronoiNoiseClass(:, 2) > 512 & centroidsOfVoronoiNoiseClass(:, 2) <= 1024, :);
            
        end
        
        if find(class == classesToVisualize, 1) > 0
            if ismember(class, borderCells)
                %We split the class found in both borders (which will be 2
                %polygons
                %First border
                centroidsOfVoronoiClass1 = centroidsOfVoronoiClass(centroidsOfVoronoiClass(:, 2) > size(voronoiClass, 2)/2, :);
                centroidsOfVoronoiNoiseClass2 = centroidsOfVoronoiNoiseClass(centroidsOfVoronoiNoiseClass(:, 2) > size(voronoiClass, 2)/2, :);
                matching1 = getMinimumMatchingBetweenPolygons(centroidsOfVoronoiClass1, centroidsOfVoronoiNoiseClass2);
                edgesBetweenLevels = [edgesBetweenLevels; matching1];
                
                %Second border
                centroidsOfVoronoiClass1 = centroidsOfVoronoiClass(centroidsOfVoronoiClass(:, 2) <= size(voronoiClass, 2)/2, :);
                centroidsOfVoronoiNoiseClass2 = centroidsOfVoronoiNoiseClass(centroidsOfVoronoiNoiseClass(:, 2) <= size(voronoiClass, 2)/2, :);
                matching2 = getMinimumMatchingBetweenPolygons(centroidsOfVoronoiClass1, centroidsOfVoronoiNoiseClass2);
                edgesBetweenLevels = [edgesBetweenLevels; matching2];
            else
                matching = getMinimumMatchingBetweenPolygons(centroidsOfVoronoiClass, centroidsOfVoronoiNoiseClass);
                edgesBetweenLevels = [edgesBetweenLevels; matching];
            end
        end
    end

end

