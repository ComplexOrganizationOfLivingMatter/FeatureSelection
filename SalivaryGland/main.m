%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginal = importdata('test\image_1_Diagram_1_Vonoroi_out.mat');
voronoiNoiseOriginal = importdata('test\image_1_Diagram_2_Vonoroi_out.mat');

voronoiOriginal = voronoiOriginal.L_original;
voronoiNoiseOriginal = voronoiNoiseOriginal.L_original;

sizeMask = size(voronoiOriginal, 1);
voronoiClass = voronoiOriginal(1:sizeMask, 1:sizeMask);
voronoiNoise = voronoiNoiseOriginal(1:sizeMask, 1:sizeMask);

[verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass);
[verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise);

[ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded ] = findingEdgesBetweenLevels(voronoiClass, voronoiNoise, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise);

plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded);

