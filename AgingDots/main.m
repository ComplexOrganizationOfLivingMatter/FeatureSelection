%% Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
rawImg = imread('E:\Pablo\PhD-miscelanious\AgingDots\data\3m\3-1.bmp');
img = rawImg(:, :, 1) - rawImg(:, :, 3);
img2 = im2bw(img(:,:,1), 0.9);
se = strel ('disk', 1);
newImg = imerode(img2, se);
imgRegions = regionprops(img2);

imgAreas = vertcat(imgRegions.Area);
imgCentroids = vertcat(imgRegions.Centroid);

lineCentroids = round(imgCentroids(imgAreas < 4, :));

newImg = zeros(size(img2, 2) , size(img2, 1));
for i = 1:size(lineCentroids, 1)
    newImg(lineCentroids(i, 2), lineCentroids(i, 1)) = 1;
end

%% get invalid area inside points
imgInvalid = rawImg;
imgInvalidBinary = im2bw(imgInvalid(:,:,1), 0.0);
se = strel('disk', 15);
imgInvalidBinaryDilated = imdilate(imgInvalidBinary, se);

img_Cropped = imgInvalidBinaryDilated(round(size(img, 1) * 2/5:size(img, 1)),:, :);
imgInvalid_L = bwlabel(img_Cropped, 8);

endPoint = [size(rawImg, 1), size(rawImg, 2)];
for label = 1:2
    [row, col] = find(imgInvalid_L == label);
    linePixels = horzcat(row, col);
    distancesToTheEnd = pdist2(linePixels, endPoint);
    closestPixels = linePixels(distancesToTheEnd == min(distancesToTheEnd), :);
    closestPixels(1) = closestPixels(1) + round(size(img, 1) * 2/5);
    
    actualPixel = closestPixels;
    while isequal(actualPixel, endPoint) == 0
        img2(actualPixel(1), actualPixel(2)) = 1;
        nextPoint1 = [actualPixel(1) + 1, actualPixel(2)];
        nextPoint2 = [actualPixel(1) - 1, actualPixel(2)];
        nextPoint3 = [actualPixel(1), actualPixel(2) + 1];
        nextPoint4 = [actualPixel(1), actualPixel(2) - 1];
        newPoints = vertcat(nextPoint1, nextPoint2, nextPoint3, nextPoint4);
        distance = pdist2(newPoints, endPoint);
        actualPixel = newPoints(distance == min(distance), :)
    end
end

figure;
imshow(img2);
figure;
imshow(imgInvalidBinaryDilated);


