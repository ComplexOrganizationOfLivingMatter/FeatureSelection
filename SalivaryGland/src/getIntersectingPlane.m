function [ midPlanePoints ] = getIntersectingPlane( edgesBetweenLevels, verticesV, verticesVNoise)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    edge = 1;
    midPlanePoints = [];
    while edge <= size(edgesBetweenLevels, 1)
        if sum(edgesBetweenLevels(edge:edge+1, 3) == 3) > 0 %% we have the mid plane point
            if edgesBetweenLevels(edge, 3) == 3
                midPlanePoints = [midPlanePoints; edgesBetweenLevels(edge, :)];
            else
                midPlanePoints = [midPlanePoints; edgesBetweenLevels(edge + 1, :)];
            end
            
        else
            midPlanePoints = [midPlanePoints; round(mean(edgesBetweenLevels(edge:edge+1, :)))];
        end
        edge = edge + 2;
    end
    midPlanePoints

end

