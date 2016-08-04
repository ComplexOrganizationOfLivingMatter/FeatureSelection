%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginal = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.mat');
voronoiNoiseOriginal = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.mat');

voronoiOriginalImage = importdata('test/Imagen_1_Diagrama_2_Vonoroi_1.png');
voronoiNoiseOriginalImage = importdata('test/Imagen_1_Diagrama_2_Vonoroi_Noise.png');

sizeMask = 500;
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




