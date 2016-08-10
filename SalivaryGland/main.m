%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginal = importdata('test\image_1_Diagram_1_Vonoroi_out.mat');
voronoiNoiseOriginal = importdata('test\image_1_Diagram_2_Vonoroi_out.mat');
validClassesOriginal = importdata('test\Valid_cells_image_1.mat');


voronoiOriginal = voronoiOriginal.L_original;
voronoiNoiseOriginal = voronoiNoiseOriginal.L_original;

%     %It gives us the region points
%     extremaVoronoi = regionprops(voronoiImageToVisualize, 'Extrema');
%     extremaVoronoi = vertcat(extremaVoronoi.Extrema);

%xMinImage = min(extremaVoronoi(extremaVoronoi(:,1) ~= 0.5));
%yMinImage = min(extremaVoronoi(extremaVoronoi(:,2) ~= 0.5));
sizeMask = size(voronoiOriginal, 1);
initMask = 1;
voronoiClass = voronoiOriginal(initMask:sizeMask, initMask:sizeMask);
voronoiNoise = voronoiNoiseOriginal(initMask:sizeMask, initMask:sizeMask);

[verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass);
[verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise);

classesToVisualize = validClassesOriginal.general_valid_cells;
%classesToVisualize = [66, 67, 70, 77];

[ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded ] = findingEdgesBetweenLevels(voronoiClass, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise, classesToVisualize);

%[ edgesBetweenLevelsVerified ] = verifyEdgesBetweenLevels(edgesBetweenLevels);

t1Points = gettingT1Transitions(edgesBetweenLevels);

plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded, classesToVisualize, t1Points);

