function [ midPlaneImage ] = paintImageMidPlane(midPlanePoints, edgesMidPlane, voronoiClass)
%PAINTIMAGEMIDPLANE Summary of this function goes here
%   Detailed explanation goes here

    midPlaneImage = zeros(size(voronoiClass, 1), size(voronoiClass, 2));
    
    numEdge = 1;
    while numEdge <= size(edgesMidPlane, 1)
        point1 = edgesMidPlane(numEdge, :);
        point2 = edgesMidPlane(numEdge + 1, :);
        t = diff([point1; point2]);
        
        S = strel('line',sqrt(sum(t.^2)),atand(t(1)/-t(2)));
        imageEdge = S.getnhood;
        
        maxHeight = max(point1(1), point2(1));
        maxWidth = max(point1(2), point2(2));
        minHeight = min(point1(1), point2(1));
        minWidth = min(point1(2), point2(2));
        
        for i = 1:size(imageEdge, 1)
           for j = 1:size(imageEdge, 2)
               midPlaneImage(i + minHeight, j + minWidth) = imageEdge(i, j) | midPlaneImage(i + minHeight, j + minWidth);
           end
        end
        
        
        numEdge = numEdge + 2;
    end

end

