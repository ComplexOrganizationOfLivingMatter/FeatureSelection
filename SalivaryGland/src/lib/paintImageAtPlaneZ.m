function [] = paintImageAtPlaneZ(voronoiImage, zAx, classesToVisualize)
%PAINTIMAGEATPLANEZ Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    
     %Here we paint only the cells found in classesToVisualize
    voronoiImageToVisualize = zeros(size(voronoiImage, 1), size(voronoiImage, 2));
    for i = 1:size(classesToVisualize, 2)
    	voronoiImageToVisualize = voronoiImageToVisualize + (voronoiImage .* (classesToVisualize(i) == voronoiImage));
    end
    
    xMaxImage = size(voronoiImageToVisualize, 1);
    yMaxImage = size(voronoiImageToVisualize, 2);
    xImage = [0 yMaxImage; 0 yMaxImage];   %# The x data for the image corners
    yImage = [0 0; xMaxImage xMaxImage];             %# The y data for the image corners
    zImage = [zAx zAx; zAx zAx];   %# The z data for the image corners
    surf(xImage,yImage,zImage,...    %# Plot the surface
         'CData', voronoiImageToVisualize,...
         'FaceColor','texturemap');
end

