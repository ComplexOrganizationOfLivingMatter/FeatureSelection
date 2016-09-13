function [ edgesBetweenLevels ] = verifyEdgesBetweenLevels( edgesBetweenLevels, voronoiClass, neighboursVerticesV, verticesV, neighboursVerticesVNoise, verticesVNoise )
%verifyEdgesBetweenLevels Remove cycles
%   Detailed explanation goes here

    %Firstly, we remove duplicated edges
    numEdge = 1;
    while 1
        edge1 = edgesBetweenLevels(numEdge, :);
        edge2 = edgesBetweenLevels(numEdge + 1, :);
        [row, ~] = find(edge1(1) == edgesBetweenLevels(:, 1) & edge1(2) == edgesBetweenLevels(:, 2) & edge1(3) == edgesBetweenLevels(:, 3));
        if isempty(row) == 0
            for numRow = 1:size(row, 1)
                realRow = row(numRow) + 1;
                if ismember(edge2, edgesBetweenLevels(realRow, :), 'rows') && realRow ~= numEdge + 1
                    edgesBetweenLevels(realRow, :) = [];
                    edgesBetweenLevels(realRow - 1, :) = [];
                    numEdge = numEdge - 2;
                    break
                end
            end
        end
        numEdge = numEdge + 2;
        if numEdge > size(edgesBetweenLevels, 1)
           break 
        end
    end
    
    for numClass = 1:max(voronoiClass(:, :))
        classesVerticesV = neighboursVerticesV(neighboursVerticesV(:, :) == numClass, :);
        uniqueNeighboursVerticesV = unique(classesVerticesV);
        uniqueNeighboursVerticesV = uniqueNeighboursVerticesV(uniqueNeighboursVerticesV ~= numClass);
        
        classesVerticesNoise = neighboursVerticesVNoise(neighboursVerticesVNoise(:, :) == numClass, :)
        uniqueNeighboursVerticesNoise = unique(classesVerticesNoise);
        uniqueNeighboursVerticesNoise = uniqueNeighboursVerticesNoise(uniqueNeighboursVerticesNoise ~= numClass);
       
        uniqueNeighbours = union(uniqueNeighboursVerticesV, uniqueNeighboursVerticesNoise);
        
        [numVerticesV, ~] = find(neighboursVerticesV(:, :) == numClass);
        [numVerticesVNoise, ~] = find(neighboursVerticesVNoise(:, :) == numClass);
        for numNeighbour = 1:size(uniqueNeighbours, 1)
            [rowsNeighbourV, ~] = find(neighboursVerticesV(:, :) == uniqueNeighboursVerticesV(numNeighbour));
            verticesSharingClassesV = intersect(numVerticesV, rowsNeighbourV);
            if size(verticesSharingClassesV, 1) > 1
                [rowsNeighbourVNoise, ~] = find(neighboursVerticesVNoise(:, :) == uniqueNeighboursVerticesNoise(numNeighbour));
                verticesSharingClassesVNoise = intersect(numVerticesVNoise, rowsNeighbourVNoise);
                
                edgesBetweenLevels(verticesV(verticesSharingClassesVNoise, :), :);
            end
        end
    end
    
    
%     totalEdges = size(edgesBetweenLevels, 1);
%     distances = zeros(totalEdges/2, 1);
%     i = 1;
%     while i <= totalEdges
%        distances((i+1)/2) = sqrt((edgesBetweenLevels(i, 1) - edgesBetweenLevels(i+1, 1))^2 + (edgesBetweenLevels(i, 2) - edgesBetweenLevels(i+1, 2))^2);
%         i = i + 2;
%     end
%     
%     while isempty(distances(isnan(distances(:)) == 0)) == 0
%         maxDistance = max(distances(:));
%         edge = find(maxDistance == distances, 1);
%         distances(edge) = [];
%         edge = edge*2 - 1;
%         duplicateEdges = [];
%         If it's the upper plane, we get the edge of the lower one
%         if mod(edge, 2) == 1
%             duplicateEdges = find(edgesBetweenLevels(edge, 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(edge, 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(edge, 3) == edgesBetweenLevels(:, 3));
%             duplicateEdges(:) = duplicateEdges(:) + 1;
%         end
%         if size(duplicateEdges, 1) > 1
%             for duplicate = 1:size(duplicateEdges, 1)
%                 consultingEdge = find(edgesBetweenLevels(duplicateEdges(duplicate), 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(duplicateEdges(duplicate), 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(duplicateEdges(duplicate), 3) == edgesBetweenLevels(:, 3));
%                 if size(consultingEdge, 1) > 1 %there's a cycle, remove the edge between the duplicates
%                     We only want real edges to erase
%                     if duplicateEdges(duplicate) == edge + 1
%                         edge
%                         duplicateEdges(duplicate)
%                         
%                         edgesBetweenLevels([edge; duplicateEdges(duplicate)], :) = [];
%                         break
%                     end
%                 end
%             end
%         end
%     end
end

