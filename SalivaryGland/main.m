%Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez


mypath = 'data\External cylindrical voronoi\';
filesVoronoi = dir(strcat(mypath, '*.mat'));

for numFileVoronoi = 1:size(filesVoronoi,1)
    %Both images have the labels and boundaries of cells
    voronoiOriginalAll = importdata(strcat(mypath, filesVoronoi(numFileVoronoi).name));
    nameFileSplitted = strsplit(filesVoronoi(numFileVoronoi).name, '_');
    sharedName = strcat(nameFileSplitted(1:4));
    sharedName = strjoin(sharedName, '_')
    nameImage = strcat(nameFileSplitted(1:2));
    nameImage = strjoin(nameImage, '_');
    
    %-------- Inner Ratio --------%
    myPathRatio = 'data\Inner cylindrical voronoi noise\Inside ratio\';
    filesVoronoiNoise = dir(strcat(myPathRatio, '*', sharedName , '*.mat'));
    myPathValidCellsRatio = 'data\Valid cells\Inside ratio\';
    filesValidCellsVoronoiNoise = dir(strcat(myPathValidCellsRatio, '*', nameImage , '*.mat'));
    outputFileName = strcat('results\Inside ratio\', sharedName, '.mat');
    
    voronoiNoiseOriginalAll = importdata(strcat(myPathRatio, filesVoronoiNoise(1).name));
    validClassesOriginal = importdata(strcat(myPathValidCellsRatio, filesValidCellsVoronoiNoise(1).name));
    disp('Data loaded')
    [ edgesBetweenLevels, t1Points, edgesMidPlane, midPlaneImage] = intersecting3DCellStructure(voronoiOriginalAll, voronoiNoiseOriginalAll, validClassesOriginal.general_valid_noise_inner_ratio_cells);
    %Save relevant data
    save(outputFileName, 'edgesBetweenLevels', 't1Points', 'edgesMidPlane', 'midPlaneImage');
    outputFigFileName = strcat('results\Inside ratio\', sharedName, '.fig');
    savefig(outputFigFileName);
    close all
    
    %-------- Outside Ratio --------%
    myPathRatio = 'data\Inner cylindrical voronoi noise\Outside ratio\';
    filesVoronoiNoise = dir(strcat(myPathRatio, '*', sharedName , '*.mat'));
    myPathValidCellsRatio = 'data\Valid cells\Outside ratio\';
    filesValidCellsVoronoiNoise = dir(strcat(myPathValidCellsRatio, '*', nameImage , '*.mat'));
    outputFileName = strcat('results\Outside ratio\', sharedName, '.mat');
    
    voronoiNoiseOriginalAll = importdata(strcat(myPathRatio, filesVoronoiNoise(1).name));
    validClassesOriginal = importdata(strcat(myPathValidCellsRatio, filesValidCellsVoronoiNoise(1).name));
    disp('Data loaded')
    [ edgesBetweenLevels, t1Points, edgesMidPlane, midPlaneImage] = intersecting3DCellStructure(voronoiOriginalAll, voronoiNoiseOriginalAll, validClassesOriginal.general_valid_noise_outside_ratio_cells);
    %Save relevant data
    save(outputFileName, 'edgesBetweenLevels', 't1Points', 'edgesMidPlane', 'midPlaneImage');
    outputFigFileName = strcat('results\Inside ratio\', sharedName, '.fig');
    savefig(outputFigFileName);
    close all
    
    %-------- Whole cell Ratio --------%
    myPathRatio = 'data\Inner cylindrical voronoi noise\Whole cell\';
    filesVoronoiNoise = dir(strcat(myPathRatio, '*', sharedName , '*.mat'));
    myPathValidCellsRatio = 'data\Valid cells\Whole cell\';
    filesValidCellsVoronoiNoise = dir(strcat(myPathValidCellsRatio, '*', nameImage , '*.mat'));
    outputFileName = strcat('results\Whole cell\', sharedName, '.mat');
    
    voronoiNoiseOriginalAll = importdata(strcat(myPathRatio, filesVoronoiNoise(1).name));
    validClassesOriginal = importdata(strcat(myPathValidCellsRatio, filesValidCellsVoronoiNoise(1).name));
    disp('Data loaded')
    [ edgesBetweenLevels, t1Points, edgesMidPlane, midPlaneImage] = intersecting3DCellStructure(voronoiOriginalAll, voronoiNoiseOriginalAll, validClassesOriginal.general_valid_noise_whole_cells);
    %Save relevant data
    save(outputFileName, 'edgesBetweenLevels', 't1Points', 'edgesMidPlane', 'midPlaneImage');
	outputFigFileName = strcat('results\Inside ratio\', sharedName, '.fig');
    savefig(outputFigFileName);
    close all
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