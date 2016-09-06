%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginalAll = importdata('data\External cylindrical voronoi\Image_2_Diagram_2_Vonoroi_out.mat');
voronoiNoiseOriginalAll = importdata('data\Inner cylindrical voronoi noise\Whole cell\Image_2_Diagram_3_Vonoroi_noise.mat');
validClassesOriginal = importdata('data\Valid cells\Whole cell\Valid_cells_image_2.mat');

voronoiClass = repmat(voronoiOriginalAll.L_original, 1, 3);
voronoiNoise = repmat(voronoiNoiseOriginalAll.L_original_noise, 1, 3);

[verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass, voronoiOriginalAll.border_cells);
[verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise, voronoiNoiseOriginalAll.border_cells_noise);

classesToVisualize = validClassesOriginal.general_valid_noise_whole_cells;
%classesToVisualize = [66, 67, 70, 77];

[ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded ] = findingEdgesBetweenLevels(voronoiClass, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise, classesToVisualize);

[ edgesBetweenLevels ] = verifyEdgesBetweenLevels(edgesBetweenLevels);

[t1Points, edgesBetweenLevels] = gettingT1Transitions(edgesBetweenLevels);

[ midPlanePoints, neighboursMidPlanePoints, edgesMidPlane ]  = getIntersectingPlane(edgesBetweenLevels, verticesV, verticesVNoise, neighboursVerticesV, neighboursVerticesVNoise, voronoiClass);

edgesMidPlane = remove3Cycle(midPlanePoints, edgesMidPlane);

midPlaneImage = paintImageMidPlane(midPlanePoints, edgesMidPlane, voronoiClass);

plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded, classesToVisualize, midPlanePoints, edgesMidPlane, midPlaneImage);


%-------------------- Testing visualizing -----------------------------%
% neighboursMidPlanePoints = cell2mat(neighboursMidPlanePoints)
% 
% topVertices = [];
% midVertices = [];
% for classToVisualize = 1:size(classesToVisualize, 2)
%     [x, ~] = find(neighboursVerticesV == classesToVisualize(classToVisualize));
%     topVertices = [topVertices; verticesV(x, :)];
%     [x, ~] = find(neighboursMidPlanePoints == classesToVisualize(classToVisualize));
%     midVertices = [midVertices; midPlanePoints(x, :)];
% end
% 
% verticesToVisualize = unique([[topVertices, ones(size(topVertices, 1), 1)*6]; midVertices], 'rows');
% verticesToVisualize(:,3) = verticesToVisualize(:,3) * 100;
% verticesToVisualize = verticesToVisualize(verticesToVisualize(:, 2) > 512 & verticesToVisualize(:, 2) < 1024, :);
% figure;
% paintAlphaShape(verticesToVisualize, [], 1);
% 
% %Painting 4 cells
% figure;
% for classToVisualize = 1:size(classesToVisualize, 2)
%     
%     verticesToVisualize = paintPolyhedron( neighboursVerticesV, [verticesV, ones(size(verticesV, 2), 1)*6], classesToVisualize, classToVisualize);
%     verticesToVisualize3 = paintPolyhedron( neighboursMidPlanePoints, midPlanePoints, classesToVisualize, classToVisualize);
%     paintAlphaShape(verticesToVisualize3, verticesToVisualize);
%     
%     verticesToVisualize2 = paintPolyhedron( neighboursVerticesVNoise, [verticesVNoise, ones(size(verticesVNoise, 2), 1)*0], classesToVisualize, classToVisualize);
%     paintAlphaShape(verticesToVisualize3, verticesToVisualize2);
% end


%-------------------- End Testing visualizing -----------------------------%