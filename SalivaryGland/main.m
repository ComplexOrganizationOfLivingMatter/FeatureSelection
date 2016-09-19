%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez


mypath = 'data\External cylindrical voronoi\';
filesVoronoi = dir(strcat(mypath, '*.mat'));

for numFileVoronoi = 1:size(filesVoronoi,1)
    %Both images have the labels and boundaries of cells
    voronoiOriginalAll = importdata(strcat(mypath, filesVoronoi(numFileVoronoi).name));
    nameFileSplitted = strsplit(filesVoronoi(numFileVoronoi).name, '_');
    sharedName = strcat(nameFileSplitted(1:4));
    sharedName = strcat(sharedName{:})
    
    
    voronoiNoiseOriginalAll = importdata('data\Inner cylindrical voronoi noise\Inside ratio\Image_1_Diagram_6_Vonoroi_noise.mat');
    validClassesOriginal = importdata('data\Valid cells\Inside ratio\Valid_cells_image_1.mat');

    disp('Data loaded')
    
    [ edgesBetweenLevels, t1Points, edgesMidPlane, midPlaneImage] = intersecting3DCellStructure(voronoiOriginalAll, voronoiNoiseOriginalAll, validClassesOriginal)
end


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