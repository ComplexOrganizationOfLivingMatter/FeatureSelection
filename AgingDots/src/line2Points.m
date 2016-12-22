function [ ] = line2Points( closestPixels, endPoint, imgToModify)
%LINE2POINTS Summary of this function goes here
%   Detailed explanation goes here
    actualPixel = closestPixels;
    while isequal(actualPixel, endPoint) == 0
        imgToModify(actualPixel(1), actualPixel(2)) = 1;
        nextPoint1 = [actualPixel(1) + 1, actualPixel(2)];
        nextPoint2 = [actualPixel(1) - 1, actualPixel(2)];
        nextPoint3 = [actualPixel(1), actualPixel(2) + 1];
        nextPoint4 = [actualPixel(1), actualPixel(2) - 1];
        newPoints = vertcat(nextPoint1, nextPoint2, nextPoint3, nextPoint4);
        distance = pdist2(newPoints, endPoint);
        actualPixel = newPoints(distance == min(distance), :);
    end
end

