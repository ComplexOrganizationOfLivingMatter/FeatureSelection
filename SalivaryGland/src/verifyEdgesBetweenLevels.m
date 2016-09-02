function [ edgesBetweenLevels ] = verifyEdgesBetweenLevels( edgesBetweenLevels )
%verifyEdgesBetweenLevels Remove cycles
%   Detailed explanation goes here
    
    totalEdges = size(edgesBetweenLevels, 1);
    distances = zeros(totalEdges/2, 1);
    i = 1;
    while i <= totalEdges
       distances((i+1)/2) = sqrt((edgesBetweenLevels(i, 1) - edgesBetweenLevels(i+1, 1))^2 + (edgesBetweenLevels(i, 2) - edgesBetweenLevels(i+1, 2))^2);
        i = i + 2;
    end
    
    while distances(isnan(distances(:)) == 0) > 0
        maxDistance = max(distances(:));
        edge = find(maxDistance == distances, 1);
        distances(edge) = [];
        edge = edge*2 - 1;
        duplicateEdges = [];
        %If it's the upper plane, we get the edge of the lower one
        if mod(edge, 2) == 1
            duplicateEdges = find(edgesBetweenLevels(edge, 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(edge, 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(edge, 3) == edgesBetweenLevels(:, 3));
            duplicateEdges(:) = duplicateEdges(:) + 1;
        end
        if size(duplicateEdges, 1) > 1
            for duplicate = 1:size(duplicateEdges, 1)
                consultingEdge = find(edgesBetweenLevels(duplicateEdges(duplicate), 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(duplicateEdges(duplicate), 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(duplicateEdges(duplicate), 3) == edgesBetweenLevels(:, 3));
                if size(consultingEdge, 1) > 1 %there's a cycle, remove the edge between the duplicates
                    %We only want real edges to erase
                    if duplicateEdges(duplicate) == edge + 1
                        edge
                        duplicateEdges(duplicate)
                        
                        edgesBetweenLevels([edge; duplicateEdges(duplicate)], :) = [];
                        break
                    end
                end
            end
        end
    end
end

