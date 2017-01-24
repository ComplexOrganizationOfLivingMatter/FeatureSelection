function [ midPlaneImage ] = paintImageMidPlane(midPlanePoints, edgesMidPlane, voronoiClass)
%PAINTIMAGEMIDPLANE Create the voronoi image of the middle plain
%   Create a hexagonal cell plane which will be the intersecting plane between
%   exterior plane of the salivary gland and the interior of it.
%   This will result in a plane like the voronoiImage and voronoi noise, having
%   as hexagonish polygons the cells of each plane.
%
%   Developed by Pablo Vicente-Munuera and Pedro Gómez-Gálvez

    %FinalPixel of the x axis
    endPixelX = round(5*size(voronoiClass, 2)/6);
    %Initial Pixel of the x axis
    initPixelX = round(1*size(voronoiClass, 2)/6);
    %Init image with all zeros
    midPlaneImage = zeros(size(voronoiClass, 1), size(voronoiClass, 2));
    
    %Starting edge
    numEdge = 1;
    %Until we go through all the edges of mid plane
    while numEdge <= size(edgesMidPlane, 1)
        %First point of the edge
        point1 = edgesMidPlane(numEdge, :);
        %Second point of the edge
        point2 = edgesMidPlane(numEdge + 1, :);
        %difference between the points
        t = diff([point1; point2]);
        %Calculate how would be the line
        S = strel('line',sqrt(sum(t.^2)),atand(t(1)/-t(2)));
        %The edge painted
        imageEdge = S.getnhood;
        
        %Minimum height of the points
        minHeight = min(point1(1), point2(1));
        %Minimum width of the points
        minWidth = min(point1(2), point2(2));
        
        %Run through the painted line
        for i = 1:size(imageEdge, 1)
           for j = 1:size(imageEdge, 2)
               %If the edge is already there, we won't overlap it
               midPlaneImage(i + minHeight, j + minWidth) = imageEdge(i, j) | midPlaneImage(i + minHeight, j + minWidth);
           end
        end
        %Next edge
        numEdge = numEdge + 2;
    end
    
    %Segment and get the classes from the image. 1 cell, 1 class.
    midPlaneLabelled = watershed(midPlaneImage, 4);
    centroids = regionprops(midPlaneLabelled);
    %Centroids
    centroidsDS = struct2dataset(centroids);
    centroids = centroidsDS.Centroid;
    centroids = round(centroids(:,:));
    %centroids = centroids(centroidsDS.Area > 1000, :);
    %We don't want all the centroids
    centroids = centroids(centroids(:, 1) > initPixelX & centroids(:, 1) < endPixelX, :);

    %Now we change the number of class to the class of the voronoi plane
    for numCentroid = 1:size(centroids, 1)
        cent = centroids(numCentroid, :);
        numClass = voronoiClass(cent(2), cent(1));
        midPlaneImage(midPlaneLabelled == midPlaneLabelled(cent(2), cent(1))) = numClass;
    end
    midPlaneImage(midPlaneImage == 1) = 0;
end

