%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginal = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.mat');
voronoiNoiseOriginal = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.mat');

voronoiOriginalImage = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.png');
voronoiNoiseOriginalImage = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.png');

sizeMask = 2048;
voronoiClass = voronoiOriginal(1:sizeMask, 1:sizeMask);
voronoiNoise = voronoiNoiseOriginal(1:sizeMask, 1:sizeMask);

voronoiImage = voronoiOriginalImage(1:sizeMask, 1:sizeMask);
voronoiNoiseImage = voronoiNoiseOriginalImage(1:sizeMask, 1:sizeMask);

% figure;
% [map r c] = susanCorner(im2double(voronoiImage));
% figure,imshow(voronoiImage),hold on
% plot(c,r,'o')

% figure;
% imshow(voronoiImage);
% hold on
% %verticesV = corner(voronoiImage, 'MinimumEigenvalue', 100000, 'QualityLevel', 0.2); % 'SensitivityFactor', 0.15
% verticesV = detectHarrisFeatures(voronoiImage, 'MinQuality', 0.1, 'FilterSize', 5);
% plot(verticesV.Location(:,1), verticesV.Location(:,2), 'r*');
% figure;
% imshow(voronoiNoise);
% hold on
% %verticesVNoise = corner(voronoiNoise, 'MinimumEigenvalue', 100000, 'QualityLevel', 0.2); % 'SensitivityFactor', 0.15
% verticesVNoise = detectHarrisFeatures(voronoiNoise, 'MinQuality', 0.1, 'FilterSize', 5);
% plot(verticesVNoise.Location(:,1), verticesVNoise.Location(:,2), 'r*');

verticesV = getVerticesAndNeighbours(voronoiClass);
verticesVNoise = getVerticesAndNeighbours(voronoiNoise);

verticesVAdded = zeros(size(verticesV,1), 1);
verticesVNoiseAdded = zeros(size(verticesVNoise, 1), 1);

edgesBetweenLevels = [];
maxDistance = size(voronoiClass, 1)/(max(voronoiClass(:))/20);

for i = 1:size(verticesV, 1)
    xMin = verticesV(i, 1) - maxDistance;
    xMax = verticesV(i, 1) + maxDistance;
    
    yMin = verticesV(i, 2) - maxDistance;
    yMax = verticesV(i, 2) + maxDistance;
    
    %Filtered zone
    vNoiseFilteredX = verticesVNoise(verticesVNoise(:,1)> xMin & verticesVNoise(:,1) < xMax, :);
    vNoiseFilteredXY = vNoiseFilteredX(vNoiseFilteredX(:,2) > yMin & vNoiseFilteredX(:, 2) < yMax, :);
    
    if size(vNoiseFilteredXY, 1) > 0
        %calculate distance between the current point and all near him.
        distancePointNoiseRegion = pdist([verticesV(i,:); vNoiseFilteredXY]);
        %Square form
        distancePointNoiseRegion = squareform(distancePointNoiseRegion);
        %We only want the distances related with our point
        distances = distancePointNoiseRegion(1,:);
        %Get the minimum distance
        minimumDistance = min(distances(2:end));
        %The number of corner (-1 because we added the first point)
        cornerNumberInZone = find(distances == minimumDistance, 1) - 1;
        if cornerNumberInZone ~= 0
            %Corner points
            cornerPoints = vNoiseFilteredXY(cornerNumberInZone, :);
            %Find the number of corner within the noise voronoi and all the area
            numberOfCornerNoise = find(verticesVNoise(:,1) == cornerPoints(:,1) & verticesVNoise(:,2) == cornerPoints(:,2));
            %Mark the vertices with them number of edges
            verticesVAdded(i) = verticesVAdded(i) + 1;
            verticesVNoiseAdded(numberOfCornerNoise) = verticesVNoiseAdded(numberOfCornerNoise) + 1;

            %the even will be points in the interior (voronoi noise) level and the
            %%odd cells will be point in the exterior (voronoi) level.
            edgesBetweenLevels = [edgesBetweenLevels; verticesV(i,:), 2; cornerPoints, 0];
        end
    end
end
figure;
%plot3(edgesBetweenLevels(:,1), edgesBetweenLevels(:,2), edgesBetweenLevels(:,3));xMaxImage = size(voronoiImage, 1);
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
hold off;

