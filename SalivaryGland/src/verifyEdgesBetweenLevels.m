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
    
    while isempty(distances(isnan(distances(:)) == 0)) == 0
        isOver = 0;
        maxDistance = max(distances(:));
        edge = find(maxDistance == distances, 1); %first point
        distances(edge) = [];
        edge = edge*2 - 1; %the real position within the distance matrix
        duplicateEdges = find(edgesBetweenLevels(edge, 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(edge, 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(edge, 3) == edgesBetweenLevels(:, 3));
        %If it's the upper plane, we get the edge of the lower one
        if mod(edge, 2) == 1
            duplicateEdges(:) = duplicateEdges(:) + 1;
        else %this will never happen
            duplicateEdges(:) = duplicateEdges(:) - 1;
        end
        %If we find more than one edge
        if size(duplicateEdges, 1) > 1
            for duplicate = 1:size(duplicateEdges, 1) %second point
                consultingEdge = find(edgesBetweenLevels(duplicateEdges(duplicate), 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(duplicateEdges(duplicate), 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(duplicateEdges(duplicate), 3) == edgesBetweenLevels(:, 3));
                if size(consultingEdge, 1) > 1 %there's a cycle, remove the edge between the duplicates
                    %We only want real edges to erase
                    for cEdge = 1:size(consultingEdge, 1)
                        if ismember(edgesBetweenLevels(consultingEdge(cEdge) - 1, :), edgesBetweenLevels(edge, :), 'rows') == 0
                            if duplicateEdges(duplicate) == consultingEdge(cEdge) %third point
                                %edge
                                %duplicateEdges(duplicate)

                                edgesBetweenLevels([consultingEdge(cEdge) - 1; duplicateEdges(duplicate)], :) = [];
                                isOver = 1;
                                break
                            end
                        end
                    end
                end
                if isOver
                    break
                end
            end
        end
    end
end

