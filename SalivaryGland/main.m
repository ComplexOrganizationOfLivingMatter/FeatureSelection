%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
%Both images have the labels and boundaries of cells
voronoiOriginalAll = importdata('data\External cylindrical voronoi\Image_1_Diagram_3_Vonoroi_out.mat');
voronoiNoiseOriginalAll = importdata('data\Inner cylindrical voronoi noise\Inside ratio\Image_1_Diagram_3_Vonoroi_noise.mat');
validClassesOriginal = importdata('data\Valid cells\Inside ratio\Valid_cells_image_1.mat');

disp('Data loaded')

voronoiClass = repmat(voronoiOriginalAll.L_original, 1, 3);
voronoiNoise = repmat(voronoiNoiseOriginalAll.L_original_noise, 1, 3);

%Get vertices and vertices' neighbours of both images
[verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass, voronoiOriginalAll.border_cells);
[verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise, voronoiNoiseOriginalAll.border_cells_noise);

%We only want to visualize the valid cells
%classesToVisualize = validClassesOriginal.general_valid_noise_inner_ratio_cells;
classesToVisualize = validClassesOriginal.general_valid_noise_whole_cells;
%You have to delete the first number
borderCells = union(voronoiOriginalAll.border_cells(2:end), voronoiNoiseOriginalAll.border_cells_noise(2:end));
%classesToVisualize = [63, 55];

disp('Vertices found')

%Create an edge between both voronoi images: VoronoiClass and VoronoiNoise
[ edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded ] = findingEdgesBetweenLevels(voronoiClass, verticesV, neighboursVerticesV, verticesVNoise, neighboursVerticesVNoise, classesToVisualize, borderCells);

disp('Edges between levels... Verifying')

%Remove unwanted (not good) vertices between planes(or levels)
[ edgesBetweenLevels ] = verifyEdgesBetweenLevels(edgesBetweenLevels, voronoiClass, neighboursVerticesV, verticesV, neighboursVerticesVNoise, verticesVNoise, classesToVisualize, borderCells);

%Find the points that create an X in the mid plane, i.e. the so call T1 transitions
[t1Points, edgesBetweenLevels] = gettingT1Transitions(edgesBetweenLevels);

disp('Mid plane...')

%Get all the points of the mid plane, which will be the middle of the edges between labels.
[ midPlanePoints, neighboursMidPlanePoints, edgesMidPlane ]  = getIntersectingPlane(edgesBetweenLevels, verticesV, verticesVNoise, neighboursVerticesV, neighboursVerticesVNoise, voronoiClass);

%Remove mistaken edges
edgesMidPlane = remove3Cycle(midPlanePoints, edgesMidPlane);

%Paint the mid image with the proper classes for the new cells (mid plane)
midPlaneImage = paintImageMidPlane(midPlanePoints, edgesMidPlane, voronoiClass);
%Plot all the information
disp('Plotting...')
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