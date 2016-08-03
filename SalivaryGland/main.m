%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginal = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.mat');
voronoiNoiseOriginal = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.mat');

voronoiOriginalImage = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.png');
voronoiNoiseOriginalImage = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.png');

sizeMask = 100;
voronoiImage = voronoiOriginalImage(1:sizeMask, 1:sizeMask);
voronoiNoise = voronoiNoiseOriginalImage(1:sizeMask, 1:sizeMask);

figure;
imshow(voronoiImage);
hold on
%verticesV = corner(voronoiImage, 'MinimumEigenvalue', 100000, 'QualityLevel', 0.2); % 'SensitivityFactor', 0.15
verticesV = detectHarrisFeatures(voronoiImage, 'MinQuality', 0.1, 'FilterSize', 5);
plot(verticesV.Location(:,1), verticesV.Location(:,2), 'r*');
figure;
imshow(voronoiNoise);
hold on
%verticesVNoise = corner(voronoiNoise, 'MinimumEigenvalue', 100000, 'QualityLevel', 0.2); % 'SensitivityFactor', 0.15
verticesVNoise = detectHarrisFeatures(voronoiNoise, 'MinQuality', 0.1, 'FilterSize', 5);
plot(verticesVNoise.Location(:,1), verticesVNoise.Location(:,2), 'r*');



verticesVAdded = zeros(size(verticesV,1), 1);
verticesVNoiseAdded = zeros(size(verticesVNoise, 1), 1);

edgesBetweenLevels = [];
maxDistance = size(voronoiImage, 1)/(max(voronoiImage(:))/20);

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
plot3(edgesBetweenLevels(:,1), edgesBetweenLevels(:,2), edgesBetweenLevels(:,3));