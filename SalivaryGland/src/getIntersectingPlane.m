function [ midPlanePoints, neighboursMidPlanePoints, edgesMidPlane ] = getIntersectingPlane( edgesBetweenLevels, verticesV, verticesVNoise, neighboursVerticesV, neighboursVerticesVNoise, img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    endPixelX = round(5*size(img, 2)/6);
    initPixelX = round(1*size(img, 2)/6);
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
        %It returns the neighbours and points of the indices
        neighboursAndPoints = cellfun(@(v) v(:), repeatedPointsWithNeighbours(1,indicesRepeats), 'UniformOutput', false);
        neighbours = cellfun(@(v) v(4:size(v,1)), neighboursAndPoints(1,:), 'UniformOutput', false);
        neighboursMidPlanePoints{end+1} = unique(vertcat(neighbours{:}))';
        midPlanePoints = [midPlanePoints; uniqueRepeatedPoints(point, :)];
    end
    
    midPlanePoints;
    neighboursMidPlanePoints = neighboursMidPlanePoints';
    
    edgesMidPlane = [];
    for point = 1:size(midPlanePoints, 1)
        if midPlanePoints(point, 2) > initPixelX && midPlanePoints(point, 2) <= endPixelX %% the portion we want
            pointNeighbours = neighboursMidPlanePoints{point}; %Neighbours of the point
            for contigousPoint = 1:size(neighboursMidPlanePoints, 1) %%Contigous points of the point
                if midPlanePoints(contigousPoint, 2) > initPixelX && midPlanePoints(contigousPoint, 2) <= endPixelX %%The portion we want
                    if size(intersect(neighboursMidPlanePoints{contigousPoint}, pointNeighbours), 2) >= 2 %if they share more than 2 classes, it is a contigous vertex
                        if ismember(midPlanePoints(contigousPoint, :), midPlanePoints(point, :), 'rows') == 0 %% if is not the same pixel
                            if abs(midPlanePoints(contigousPoint, 2) - midPlanePoints(point, 2)) < (endPixelX - initPixelX)/10%if it is not too far
                                edgesMidPlane = [edgesMidPlane; midPlanePoints(point, :); midPlanePoints(contigousPoint, :)];
                            end
                        end
                    end
                end
            end
        end
    end
    %edgesMidPlane = unique(midPlanePoints, 'rows');
end

