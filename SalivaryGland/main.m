%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginalAll = importdata('test\image_1_Diagram_1_Vonoroi_out.mat');
voronoiNoiseOriginalAll = importdata('test\image_1_Diagram_2_Vonoroi_out.mat');
validClassesOriginal = importdata('test\Valid_cells_image_1.mat');


voronoiClass = repmat(voronoiOriginalAll.L_original, 1, 3);
voronoiNoise = repmat(voronoiNoiseOriginalAll.L_original, 1, 3);

%xMinImage = min(extremaVoronoi(extremaVoronoi(:,1) ~= 0.5));
%yMinImage = min(extremaVoronoi(extremaVoronoi(:,2) ~= 0.5));

[verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass, voronoiOriginalAll.border_cells);
[verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise, voronoiNoiseOriginalAll.border_cells);

classesToVisualize = validClassesOriginal.general_valid_cells;
%classesToVisualize = [66, 67, 70, 77];

[ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded ] = findingEdgesBetweenLevels(voronoiClass, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise, classesToVisualize);

[ edgesBetweenLevels ] = verifyEdgesBetweenLevels(edgesBetweenLevels);

[t1Points, edgesBetweenLevels] = gettingT1Transitions(edgesBetweenLevels);

[ midPlanePoints, neighboursMidPlanePoints, edgesMidPlane ]  = getIntersectingPlane(edgesBetweenLevels, verticesV, verticesVNoise, neighboursVerticesV, neighboursVerticesVNoise, voronoiClass);

edgesMidPlane = remove3Cycle(midPlanePoints, edgesMidPlane);

midPlaneImage = paintImageMidPlane(midPlanePoints, edgesMidPlane, voronoiClass);

%testing
neighboursMidPlanePoints = cell2mat(neighboursMidPlanePoints)
figure;
for classToVisualize = 1:size(classesToVisualize, 2)
    
    verticesToVisualize = paintPolyhedron( neighboursVerticesV, verticesV, classesToVisualize, classToVisualize);
    verticesToVisualize3 = paintPolyhedron( neighboursMidPlanePoints, midPlanePoints, classesToVisualize, classToVisualize);
    paintAlphaShape(verticesToVisualize3, verticesToVisualize);
    
    verticesToVisualize2 = paintPolyhedron( neighboursVerticesVNoise, verticesVNoise, classesToVisualize, classToVisualize);
    paintAlphaShape(verticesToVisualize3, verticesToVisualize2);
end



plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded, classesToVisualize, midPlanePoints, edgesMidPlane, midPlaneImage);


