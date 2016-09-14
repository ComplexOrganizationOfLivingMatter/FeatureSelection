function [ midPlanePoints, neighboursMidPlanePoints, edgesMidPlane ] = getIntersectingPlane( edgesBetweenLevels, verticesV, verticesVNoise, neighboursVerticesV, neighboursVerticesVNoise, img)
%GETINTERSECTINGPLANE Summary of this function goes here
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
            if size(neighboursPlaneV, 2) > size(neighboursPlaneVNoise, 2)
                neighboursMidPlanePoints{end+1} = neighboursPlaneV;
            else
                neighboursMidPlanePoints{end+1} = neighboursPlaneVNoise;
            end
        end
        edge = edge + 2;
    end
    
    if size(repeatedPointsWithNeighbours, 1) > 0
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
    end
    
    midPlanePoints;
    neighboursMidPlanePoints = neighboursMidPlanePoints';
    
    edgesMidPlane = [];
    for point = 1:size(midPlanePoints, 1)
        if midPlanePoints(point, 2) > initPixelX && midPlanePoints(point, 2) <= endPixelX %% the portion we want
            pointNeighbours = neighboursMidPlanePoints{point}; %Neighbours of the point
            for contigousPoint = 1:size(neighboursMidPlanePoints, 1) %%Contigous points of the point
                if ismember(midPlanePoints(contigousPoint, :), midPlanePoints(point, :), 'rows') == 0 %% if is not the same pixel
                    if midPlanePoints(contigousPoint, 2) > initPixelX && midPlanePoints(contigousPoint, 2) <= endPixelX %%The portion we want
                        if abs(midPlanePoints(contigousPoint, 2) - midPlanePoints(point, 2)) < (endPixelX - initPixelX)/10 %if it is not too far
                            maxNeighbours = max(size(pointNeighbours, 2), size(neighboursMidPlanePoints{contigousPoint}, 2));
                            if maxNeighbours == 3 % a normal point
                                if size(intersect(neighboursMidPlanePoints{contigousPoint}, pointNeighbours), 2) >= 2 %if they share more than 2 classes, it is a contigous vertex
                                    edgesMidPlane = [edgesMidPlane; midPlanePoints(point, :); midPlanePoints(contigousPoint, :)];
                                end
                            else %a point with an intersection
                                if size(intersect(neighboursMidPlanePoints{contigousPoint}, pointNeighbours), 2) > 2 %if they share more than 2 classes, it is a contigous vertex
                                    edgesMidPlane = [edgesMidPlane; midPlanePoints(point, :); midPlanePoints(contigousPoint, :)];
                                elseif size(intersect(neighboursMidPlanePoints{contigousPoint}, pointNeighbours), 2) == 2 %sharing 2 classe
                                    if min(size(pointNeighbours, 2), size(neighboursMidPlanePoints{contigousPoint}, 2)) == 3 % and one of them is a point without intersection
                                        edgesMidPlane = [edgesMidPlane; midPlanePoints(point, :); midPlanePoints(contigousPoint, :)];
                                    else
                                        contigousPoint
                                        edgesMidPlane = [edgesMidPlane; midPlanePoints(point, :); midPlanePoints(contigousPoint, :)];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    edgesMidPlane = round(edgesMidPlane(:, :));
    midPlanePoints = round(midPlanePoints(:, :));
end

