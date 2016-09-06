function [ midPlaneImage ] = paintImageMidPlane(midPlanePoints, edgesMidPlane, voronoiClass)
%PAINTIMAGEMIDPLANE Summary of this function goes here
%   Detailed explanation goes here
    endPixelX = round(5*size(voronoiClass, 2)/6);
    initPixelX = round(1*size(voronoiClass, 2)/6);
    midPlaneImage = zeros(size(voronoiClass, 1), size(voronoiClass, 2));
    
    
    numEdge = 1;
    while numEdge <= size(edgesMidPlane, 1)
        point1 = edgesMidPlane(numEdge, :);
        point2 = edgesMidPlane(numEdge + 1, :);
        t = diff([point1; point2]);
        
        S = strel('line',sqrt(sum(t.^2)),atand(t(1)/-t(2)));
        %The edge painted
        imageEdge = S.getnhood;
        
        minHeight = min(point1(1), point2(1));
        minWidth = min(point1(2), point2(2));
        
        for i = 1:size(imageEdge, 1)
           for j = 1:size(imageEdge, 2)
               %If the edge is already there, we won't overlap it
               midPlaneImage(i + minHeight, j + minWidth) = imageEdge(i, j) | midPlaneImage(i + minHeight, j + minWidth);
           end
        end
        
        numEdge = numEdge + 2;
    end
    
    midPlaneLabelled = watershed(midPlaneImage, 4);
    centroids = regionprops(midPlaneLabelled);
    centroidsDS = struct2dataset(centroids);
    centroids = centroidsDS.Centroid;
    centroids = round(centroids(:,:));
    %centroids = centroids(centroidsDS.Area > 1000, :);
    centroids = centroids(centroids(:, 1) > initPixelX & centroids(:, 1) < endPixelX, :);
    
    %midPlaneImage = ~midPlaneImage;
    
    for numCentroid = 1:size(centroids, 1)
        cent = centroids(numCentroid, :);
        numClass = voronoiClass(cent(2), cent(1));
        midPlaneImage(midPlaneLabelled == midPlaneLabelled(cent(2), cent(1))) = numClass;
    end
    midPlaneImage(midPlaneImage == 1) = 0;
end

