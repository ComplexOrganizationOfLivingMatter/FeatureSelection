function [ t1Points ] = gettingT1Transitions( edgesBetweenLevels )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    edge = 1;
    t1Points = [];
    while edge <= size(edgesBetweenLevels, 1)
        duplicatedEdges = find(edgesBetweenLevels(edge, 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(edge, 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(edge, 3) == edgesBetweenLevels(:, 3));
        duplicatedEdges = unique(duplicatedEdges, 'rows');
        duplicatedEdges(:) = duplicatedEdges(:) + 1;
        
        if size(duplicatedEdges, 1) > 1
            sharingSameVertices = 0;
            pointsConsulted = [];
            for duplicate = 1:size(duplicatedEdges, 1)
                consultingEdges = find(edgesBetweenLevels(duplicatedEdges(duplicate), 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(duplicatedEdges(duplicate), 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(duplicatedEdges(duplicate), 3) == edgesBetweenLevels(:, 3)); 
                if size(consultingEdges, 1) > 1
                    for consultingEdge = 1:size(consultingEdges, 1)
                        if sum(edgesBetweenLevels(consultingEdges(consultingEdge)-1, :) ~= edgesBetweenLevels(edge, :)) > 0
                            sharingSameVertices = sharingSameVertices + 1;
                            pointsConsulted = [pointsConsulted; edgesBetweenLevels(consultingEdges(consultingEdge)-1, :)];
                            break;
                        end
                    end
                end
            end
            pAux = unique(edgesBetweenLevels(duplicatedEdges(:), :), 'rows');
            if sharingSameVertices > 1 && size(pAux, 1) > 1
                p1 = unique(pointsConsulted, 'rows')
                p2 = pAux(1, :)
                p3 = edgesBetweenLevels(edge, :)
                p4 = pAux(2, :)
                
                
                t1Points = [t1Points; mean([p1; p2; p3; p4])];
            end
        end
        edge = edge + 2;
    end
    t1Points = unique(t1Points, 'rows');
end

