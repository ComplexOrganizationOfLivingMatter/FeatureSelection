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

edgesBetweenLevels = findingEdgesBetweenLevels(voronoiClass, voronoiNoise);

plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels);

