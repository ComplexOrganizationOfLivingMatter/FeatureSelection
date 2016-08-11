function [ ] = plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded, classesToVisualize, t1Points)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %plot image
    figure;
    %plot3(edgesBetweenLevels(:,1), edgesBetweenLevels(:,2), edgesBetweenLevels(:,3));xMaxImage = size(voronoiImage, 1);
    %Here we paint only the cells found in classesToVisualize
    voronoiImageToVisualize = zeros(size(voronoiClass, 1), size(voronoiClass, 2));
    for i = 1:size(classesToVisualize, 2)
    	voronoiImageToVisualize = voronoiImageToVisualize + (voronoiClass .* (classesToVisualize(i) == voronoiClass));
    end
    
    zAx = 6;

    xMaxImage = size(voronoiImageToVisualize, 1);
    yMaxImage = size(voronoiImageToVisualize, 2);
    xImage = [0 yMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage xMaxImage];             %# The y data for the image corners
    zImage = [zAx zAx; zAx zAx];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData', voronoiImageToVisualize,...
         'FaceColor','texturemap');
    hold on;
    voronoiNoiseToVisualize = zeros(size(voronoiNoise, 1), size(voronoiNoise, 2));
    for i = 1:size(classesToVisualize, 2)
    	voronoiNoiseToVisualize = voronoiNoiseToVisualize + (voronoiNoise .* (classesToVisualize(i) == voronoiNoise));
    end
    xMaxImage = size(voronoiNoiseToVisualize, 1);
    yMaxImage = size(voronoiNoiseToVisualize, 2);
    xImage = [0 yMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage xMaxImage];             %# The y data for the image corners
    zImage = [0 0; 0 0];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData',voronoiNoiseToVisualize,...
         'FaceColor','texturemap');
    numRow = 1;
    while numRow < size(edgesBetweenLevels,1)
        plot3(edgesBetweenLevels(numRow:numRow+1,2), edgesBetweenLevels(numRow:numRow+1,1), edgesBetweenLevels(numRow:numRow+1,3), 'LineWidth', 5);
        numRow = numRow + 2;
    end
    
%     numRow = 1;
%     while numRow < size(t1Points, 1)
%         plot3(t1Points(numRow, 2), t1Points(numRow, 1), t1Points(numRow, 3), 'o');
%         numRow = numRow + 1;
%     end
    

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
    axis([513 1024 0 512])
    colormap colorcube

    hold off;

end

