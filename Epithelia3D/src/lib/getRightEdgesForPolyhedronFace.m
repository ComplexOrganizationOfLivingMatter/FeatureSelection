function [ newEdges ] = getRightEdgesForPolyhedronFace( edgesBetweenLevels, verticesPlane6, verticesPlane0)
%GETRIGHTEDGESFORPOLYHEDRONFACE Check and correct if the face connecting 2 classes is properly formed
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    
    %If we find more than 2 edges, then we have
    %duplicated edges
    newEdges = [];
    verticesWeWantToVerifyPlane6 = unique(edgesBetweenLevels(verticesPlane6, :), 'rows');
    verticesWeWantToVerifyPlane0 = unique(edgesBetweenLevels(verticesPlane0, :), 'rows');
    
    edgesToRemovePlane6 = ismember(edgesBetweenLevels(edgesBetweenLevels(:, 3) == 6, :), verticesWeWantToVerifyPlane6, 'rows');
    edgesToRemovePlane0 = ismember(edgesBetweenLevels(edgesBetweenLevels(:, 3) == 0, :), verticesWeWantToVerifyPlane0, 'rows');
    %We find the consecutive rows.
    edgesToRemove = edgesToRemovePlane6 & edgesToRemovePlane0;
    
    verticesWeWantToVerifyPlane0 = edgesBetweenLevels(edgesBetweenLevels(:, 3) == 0, :);
    verticesWeWantToVerifyPlane0 = unique(verticesWeWantToVerifyPlane0(edgesToRemove, :), 'rows');
    
    verticesWeWantToVerifyPlane6 = edgesBetweenLevels(edgesBetweenLevels(:, 3) == 6, :);
    verticesWeWantToVerifyPlane6 = unique(verticesWeWantToVerifyPlane6(edgesToRemove, :), 'rows');
    
    %if we have 4 vertices connected by more than 4 edges (and not in a good way)
    if (size(verticesWeWantToVerifyPlane6, 1) > 1 && size(verticesWeWantToVerifyPlane0, 1) > 1)
        %%% We'll get the minimum combination of the 4 vertices
        distanceVertices = pdist([verticesWeWantToVerifyPlane6; verticesWeWantToVerifyPlane0]);
        distanceVertices = squareform(distanceVertices);
        
        %Remove distances between the same plane
        distanceVertices(1:size(verticesWeWantToVerifyPlane6, 1), 1:size(verticesWeWantToVerifyPlane6, 1)) = NaN;
        distanceVertices(size(verticesWeWantToVerifyPlane6, 1)+1:size(verticesWeWantToVerifyPlane6, 1) + size(verticesWeWantToVerifyPlane0, 1), :) = NaN;
        
        newEdges = [];
        %2 combinations possible with 4 vertices
        combination1 = distanceVertices(1, 3) + distanceVertices(2, 4);
        combination2 = distanceVertices(2, 3) + distanceVertices(1, 4);
        
        %We check which combinations is better (i.e. the closest one)
        cols = [3; 4];
        realCol = cols - size(verticesWeWantToVerifyPlane6, 1);
        if combination1 < combination2
            rows = [1; 2];
        else
            rows = [2; 1];
        end
        %Then, we add the selected vertices
        newEdges = [verticesWeWantToVerifyPlane6(rows(1), :); verticesWeWantToVerifyPlane0(realCol(1), :)];
        newEdges = [newEdges; verticesWeWantToVerifyPlane6(rows(2), :); verticesWeWantToVerifyPlane0(realCol(2), :)];
    end
end

