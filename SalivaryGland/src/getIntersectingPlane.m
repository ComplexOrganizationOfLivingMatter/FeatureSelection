function [ midPlanePoints, neighboursMidPlanePoints ] = getIntersectingPlane( edgesBetweenLevels, verticesV, verticesVNoise, neighboursVerticesV, neighboursVerticesVNoise)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    edge = 1;
    midPlanePoints = [];
    repeatedPointsWithNeighbours = {};
    neighboursMidPlanePoints = {};
    while edge <= size(edgesBetweenLevels, 1)
        if sum(edgesBetweenLevels(edge:edge+1, 3) == 3) > 0 %% we have the mid plane point
            if edgesBetweenLevels(edge, 3) == 3
                neighboursPlaneVNoise = neighboursVerticesVNoise(ismember(verticesVNoise, edgesBetweenLevels(edge+1, 1:2), 'rows'), :);
                repeatedPointsWithNeighbours{end+1} = [edgesBetweenLevels(edge, :), neighboursPlaneVNoise];
            else
                neighboursPlaneV = neighboursVerticesV(ismember(verticesV, edgesBetweenLevels(edge, 1:2), 'rows'), :);
                repeatedPointsWithNeighbours{end+1} = [edgesBetweenLevels(edge + 1, :), neighboursPlaneV];
            end
        else
            neighboursPlaneV = neighboursVerticesV(ismember(verticesV, edgesBetweenLevels(edge, 1:2), 'rows'), :);
            neighboursPlaneVNoise = neighboursVerticesVNoise(ismember(verticesVNoise, edgesBetweenLevels(edge+1, 1:2), 'rows'), :);
            midPlanePoints = [midPlanePoints; round(mean(edgesBetweenLevels(edge:edge+1, :)))];
            neighboursMidPlanePoints{end+1} = union(neighboursPlaneV, neighboursPlaneVNoise);
        end
        edge = edge + 2;
    end
    repeatedPoints = cellfun(@(v) v(1:3), repeatedPointsWithNeighbours(1,:), 'UniformOutput', false);
    repeatedPoints = repeatedPoints';
    repeatedPoints = vertcat(repeatedPoints{:});
    uniqueRepeatedPoints = unique(repeatedPoints, 'rows');
    for point = 1:size(uniqueRepeatedPoints, 1)
        indicesRepeats = ismember(repeatedPoints, uniqueRepeatedPoints(point, :), 'rows');
        neighboursAndPoints = cellfun(@(v) v(:), repeatedPointsWithNeighbours(1,indicesRepeats), 'UniformOutput', false);
        neighbours = cellfun(@(v) v(4:size(v,1)), neighboursAndPoints(1,:), 'UniformOutput', false);
        neighboursMidPlanePoints{end+1} = unique(vertcat(neighbours{:}))';
        midPlanePoints = [midPlanePoints; uniqueRepeatedPoints(point, :)];
    end
    
    midPlanePoints
    neighboursMidPlanePoints = neighboursMidPlanePoints';

end

