function [ ] = plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded, classesToVisualize, t1Points)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %plot image
    figure;
    %plot3(edgesBetweenLevels(:,1), edgesBetweenLevels(:,2), edgesBetweenLevels(:,3));xMaxImage = size(voronoiImage, 1);
    voronoiImageToVisualize = zeros(size(voronoiClass, 1));
    for i = 1:size(classesToVisualize, 2)
    	voronoiImageToVisualize = voronoiImageToVisualize + (voronoiClass .* (classesToVisualize(i) == voronoiClass));
    end
    
    zAx = 6;

    xMaxImage = size(voronoiImageToVisualize, 1);
    yMaxImage = size(voronoiImageToVisualize, 2);
    xImage = [0 xMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage yMaxImage];             %# The y data for the image corners
    zImage = [zAx zAx; zAx zAx];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData', voronoiImageToVisualize,...
         'FaceColor','texturemap');
    hold on;
    voronoiNoiseToVisualize = zeros(size(voronoiNoise, 1));
    for i = 1:size(classesToVisualize, 2)
    	voronoiNoiseToVisualize = voronoiNoiseToVisualize + (voronoiNoise .* (classesToVisualize(i) == voronoiNoise));
    end
    xMaxImage = size(voronoiImageToVisualize, 1);
    yMaxImage = size(voronoiImageToVisualize, 2);
    xImage = [0 xMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage yMaxImage];             %# The y data for the image corners
    zImage = [0 0; 0 0];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData',voronoiNoiseToVisualize,...
         'FaceColor','texturemap');
    numRow = 1;
    while numRow < size(edgesBetweenLevels,1)
        plot3(edgesBetweenLevels(numRow:numRow+1,2), edgesBetweenLevels(numRow:numRow+1,1), edgesBetweenLevels(numRow:numRow+1,3), 'LineWidth', 5);
        numRow = numRow + 2;
    end
    
    while numRow < size(t1Points, 1)
        plot3(t1Points(numRow, 2), t1Points(numRow, 1), t1Points(numRow, 3));
    end
    

%     missingVerticesNum = find(verticesVAdded == 0);
%     missingVertices = verticesV(missingVerticesNum, :);
% 
%     for i = 1:size(missingVertices, 1)
%         plot3(missingVertices(i, 2), missingVertices(i, 1), 2, 'r*');
%     end
% 
%     missingVerticesNum = find(verticesVNoiseAdded == 0);
%     missingVertices = verticesVNoise(missingVerticesNum, :);
% 
%     for i = 1:size(missingVertices, 1)
%         plot3(missingVertices(i, 2), missingVertices(i, 1), 0, 'r*');
%     end

    alpha(0.3);

    hold off;

end

