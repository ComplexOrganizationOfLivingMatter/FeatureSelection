function [ ] = plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %plot image
    figure;
    %plot3(edgesBetweenLevels(:,1), edgesBetweenLevels(:,2), edgesBetweenLevels(:,3));xMaxImage = size(voronoiImage, 1);
    xMaxImage = size(voronoiClass, 1);
    yMaxImage = size(voronoiClass, 2);
    xImage = [0 xMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage yMaxImage];             %# The y data for the image corners
    zImage = [2 2; 2 2];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData',voronoiClass,...
         'FaceColor','texturemap');
    hold on;
    xMaxImage = size(voronoiNoise, 1);
    yMaxImage = size(voronoiNoise, 2);
    xImage = [0 xMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage yMaxImage];             %# The y data for the image corners
    zImage = [0 0; 0 0];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData',voronoiNoise,...
         'FaceColor','texturemap');
    numRow = 1;
    while numRow < size(edgesBetweenLevels,1)
        plot3(edgesBetweenLevels(numRow:numRow+1,2), edgesBetweenLevels(numRow:numRow+1,1), edgesBetweenLevels(numRow:numRow+1,3));
        numRow = numRow + 2;
    end

    missingVerticesNum = find(verticesVAdded == 0);
    missingVertices = verticesV(missingVerticesNum, :);

    for i = 1:size(missingVertices, 1)
        plot3(missingVertices(i, 2), missingVertices(i, 1), 2, 'r*');
    end

    missingVerticesNum = find(verticesVNoiseAdded == 0);
    missingVertices = verticesVNoise(missingVerticesNum, :);

    for i = 1:size(missingVertices, 1)
        plot3(missingVertices(i, 2), missingVertices(i, 1), 0, 'r*');
    end


    hold off;

end

