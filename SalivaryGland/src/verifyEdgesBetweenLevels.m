function [ edgesBetweenLevels ] = verifyEdgesBetweenLevels( edgesBetweenLevels, voronoiClass, neighboursVerticesV, verticesV, neighboursVerticesVNoise, verticesVNoise, classesToVisualize, borderCells )
%VERIFYEDGESBETWEENLEVELS Remove cycles within the face of the cell
%   Having the edges forming a face of the cell's polygon, we now check if it is formed properly.
%   It wouldn't be correct, and, thus, will be removed some edge, if there is an edge connecting
%   2 vertices that are already connected with other vertices. The wrong edge will formed an 'N' at the cell.
%   We will remove the edge connecting both lines of the 'N'.
    
    for numClass = 1:max(voronoiClass(:)) %NumClasses will always be the last label of the image (usually, 100)
        if ismember(numClass, classesToVisualize) %if we want to visualize this class
            %Neighbours of the actual class in Voronoi (or plane 6)
            [rowNeighbourV, ~] = find(neighboursVerticesV(:, :) == numClass);
            %all the classes
            classesVerticesV = neighboursVerticesV(rowNeighbourV, :);
            %But not repeated
            uniqueNeighboursVerticesV = unique(classesVerticesV);
            %And not the same class
            uniqueNeighboursVerticesV = uniqueNeighboursVerticesV(uniqueNeighboursVerticesV ~= numClass);

            %Neighbours of the actual class in Voronoi noise (or plane 0)
            [rowNeighbourVNoise, ~] = find(neighboursVerticesVNoise(:, :) == numClass);
            %But not repeated
            classesVerticesNoise = neighboursVerticesVNoise(rowNeighbourVNoise, :);
            %But not repeated
            uniqueNeighboursVerticesNoise = unique(classesVerticesNoise);
            %And not the same class
            uniqueNeighboursVerticesNoise = uniqueNeighboursVerticesNoise(uniqueNeighboursVerticesNoise ~= numClass);

            %All the unique neighbours sharing in both planes (which will become the mid plane or plane 3)
            uniqueNeighbours = union(uniqueNeighboursVerticesV, uniqueNeighboursVerticesNoise);

            %Go through the unique neighbours of numClass
            for numNeighbour = 1:size(uniqueNeighbours, 1)
                %Get only the neighbours of one neighbour of numClass
                [rowsNeighbourV, ~] = find(neighboursVerticesV(:, :) == uniqueNeighbours(numNeighbour));
                %Then, we intersect, seeing what they neighbours they share
                verticesSharingClassesV = intersect(rowNeighbourV, rowsNeighbourV);
                %If they share more than one, that would mean they're connected in the plane
                if size(verticesSharingClassesV, 1) > 1
                    %We did that again for the other plane
                    [rowsNeighbourVNoise, ~] = find(neighboursVerticesVNoise(:, :) == uniqueNeighbours(numNeighbour));
                    verticesSharingClassesVNoise = intersect(rowNeighbourVNoise, rowsNeighbourVNoise);
                    if size(verticesSharingClassesV, 1) > 1

                        %%% Get the edges of the plane 6 of numClass
                        verticesPlane6 = [];
                        for numVertex = 1:size(verticesSharingClassesV, 1)
                            vertices1 = ismember(edgesBetweenLevels(:, 1:2), verticesV(verticesSharingClassesV(numVertex), :),  'rows');
                            verticesPlane6 = [verticesPlane6; find(vertices1)];
                        end

                        %Remove the edges of other planes
                        verticesPlane6Aux = edgesBetweenLevels(verticesPlane6, 3) == 6;
                        %And get the vertices of the other plane
                        verticesPlane6 = verticesPlane6(verticesPlane6Aux) + 1;
                        verticesPlane0 = [];
                        %Now, we check if they're really of plane 0
                        for numVertex = 1:size(verticesSharingClassesVNoise, 1)
                            vertices2 = ismember(edgesBetweenLevels(verticesPlane6, 1:2), verticesVNoise(verticesSharingClassesVNoise(numVertex), :), 'rows');
                            verticesPlane0 = [verticesPlane0; verticesPlane6(vertices2)];
                        end
                        %Remove the edges from other planes
                        verticesPlane6Aux = find(edgesBetweenLevels(verticesPlane0, 3) == 0);
                        %And get the correct ones of plane 6
                        verticesPlane6 = verticesPlane0(verticesPlane6Aux) - 1;

                        %%% Having the edges forming a face of the cell's polygon, we now check if it is formed properly.
                        %%% It wouldn't be correct, and, thus, will be removed some edge, if there is an edge connecting
                        %%% 2 vertices that are already connected with other vertices. The wrong edge will formed an N at the cell.
                        if ismember(numClass, borderCells) == 0
                            %We discard edges beyond the middle image
                            indicesVerticesPlane6 = edgesBetweenLevels(verticesPlane6, 2) > (size(voronoiClass, 2)/3) & edgesBetweenLevels(verticesPlane6, 2) <= (2*size(voronoiClass, 2)/3);
                            indicesVerticesPlane0 = edgesBetweenLevels(verticesPlane0, 2) > (size(voronoiClass, 2)/3) & edgesBetweenLevels(verticesPlane0, 2) <= (2*size(voronoiClass, 2)/3);
                            %Checking
                            newEdges = getRightEdgesForPolyhedronFace(edgesBetweenLevels, verticesPlane6(indicesVerticesPlane6), verticesPlane0(indicesVerticesPlane0));
                            if isempty(newEdges) == 0
                                %We remove all the edges forming the face
                                edgesBetweenLevels([verticesPlane6(indicesVerticesPlane6); verticesPlane0(indicesVerticesPlane0)], :) = [];
                                %And add the right not duplicated ones
                                edgesBetweenLevels = [edgesBetweenLevels; newEdges];
                            end
                        else %if it is a border class, we split it in two different polygons
                            %1 border
                            verticesPlane6Border1 = edgesBetweenLevels(verticesPlane6, 2) > (size(voronoiClass, 2)/2);
                            verticesPlane0Border1 = edgesBetweenLevels(verticesPlane0, 2) > (size(voronoiClass, 2)/2);
                            %The other
                            verticesPlane6Border2 = edgesBetweenLevels(verticesPlane6, 2) <= (size(voronoiClass, 2)/2);
                            verticesPlane0Border2 = edgesBetweenLevels(verticesPlane0, 2) <= (size(voronoiClass, 2)/2);
                            
                            newEdges1 = getRightEdgesForPolyhedronFace(edgesBetweenLevels, verticesPlane6(verticesPlane6Border1), verticesPlane0(verticesPlane0Border1));
                            newEdges2 = getRightEdgesForPolyhedronFace(edgesBetweenLevels, verticesPlane6(verticesPlane6Border2), verticesPlane0(verticesPlane0Border2));
                            %Remove the old ones and the new ones
                            edgesToRemove = [];
                            newEdges = [];
                            if isempty(newEdges1) == 0
                                %We remove all the edges forming the face
                                edgesToRemove = [edgesToRemove; verticesPlane6(verticesPlane6Border1); verticesPlane0(verticesPlane0Border1)];
                                %And add the right not duplicated ones
                                newEdges = [newEdges; newEdges1];
                            end
                            if isempty(newEdges2) == 0
                                %We remove all the edges forming the face
                                edgesToRemove = [edgesToRemove; verticesPlane6(verticesPlane6Border2); verticesPlane0(verticesPlane0Border2)];
                                %And add the right not duplicated ones
                                newEdges = [newEdges; newEdges2];
                            end
                            %We remove the edges like this, to protect the indices.
                            %If we would remove the edges on at a time, the indices
                            %won't be fine.
                            edgesBetweenLevels(edgesToRemove, :) = [];
                            edgesBetweenLevels = [edgesBetweenLevels; newEdges];
                        end
                    end
                end
            end
        end
    end
    
%%% OLD ALGORITHM OF REMOCING CYCLES OF 3 EDGES
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

