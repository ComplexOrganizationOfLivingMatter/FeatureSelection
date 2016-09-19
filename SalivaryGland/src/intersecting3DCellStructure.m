function [ edgesBetweenLevels, t1Points, edgesMidPlane, midPlaneImage] = intersecting3DCellStructure(voronoiOriginalAll, voronoiNoiseOriginalAll, validClassesOriginal)
%INTERSECTING3DCELLSTRUCTURE Summary of this function goes here
%   Detailed explanation goes here

    voronoiClass = repmat(voronoiOriginalAll.L_original, 1, 3);
    voronoiNoise = repmat(voronoiNoiseOriginalAll.L_original_noise, 1, 3);

    %Get vertices and vertices' neighbours of both images
    [verticesV, neighboursVerticesV] = getVerticesAndNeighbours(voronoiClass, voronoiOriginalAll.border_cells);
    [verticesVNoise, neighboursVerticesVNoise] = getVerticesAndNeighbours(voronoiNoise, voronoiNoiseOriginalAll.border_cells_noise);

    %We only want to visualize the valid cells
    %classesToVisualize = validClassesOriginal.general_valid_noise_inner_ratio_cells;
    classesToVisualize = validClassesOriginal.general_valid_noise_inner_ratio_cells;
    %You have to delete the first number
    borderCells = union(voronoiOriginalAll.border_cells(2:end), voronoiNoiseOriginalAll.border_cells_noise(2:end));
    %classesToVisualize = [15, 30, 31, 23];

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
end

