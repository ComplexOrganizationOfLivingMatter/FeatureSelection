function [ t1Points, edgesBetweenLevelsAux ] = gettingT1Transitions( edgesBetweenLevels )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    edge = 1;
    t1Points = [];
    edgesBetweenLevelsAux = edgesBetweenLevels;
    while edge <= size(edgesBetweenLevels, 1)
        %Firstly the points adjacents to the first point
        duplicatedEdges = find(edgesBetweenLevels(edge, 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(edge, 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(edge, 3) == edgesBetweenLevels(:, 3));
        
        %If there are more than 1. It could appear the transition.
        if size(duplicatedEdges, 1) > 1
            pointsConsulted = [];
            pointsDuplicatedConsulted = [];
            for duplicate = 1:size(duplicatedEdges, 1) %second points %there has to be more than one
                %It always be an odd number, then if we want its
                %neighbours, we have to add 1 to the edge number.
                consultingEdges = find(edgesBetweenLevels(duplicatedEdges(duplicate) + 1, 1) == edgesBetweenLevels(:, 1) & edgesBetweenLevels(duplicatedEdges(duplicate) + 1, 2) == edgesBetweenLevels(:, 2) & edgesBetweenLevels(duplicatedEdges(duplicate) + 1, 3) == edgesBetweenLevels(:, 3)); 
                
                if size(consultingEdges, 1) > 1
                    for consultingEdge = 1:size(consultingEdges, 1) %third point
                        if sum(edgesBetweenLevels(consultingEdges(consultingEdge) - 1, :) ~= edgesBetweenLevels(edge, :)) > 0
                            pointsConsulted = [pointsConsulted; consultingEdges(consultingEdge)-1];
                            pointsDuplicatedConsulted = [pointsDuplicatedConsulted; duplicatedEdges(duplicate) + 1];
                            break;
                        end
                    end
                end
            end
            
            
            uniqueFinalPoints = unique(edgesBetweenLevels(pointsDuplicatedConsulted(:), :), 'rows');
            if size(pointsConsulted, 1) > 1 && size(uniqueFinalPoints, 1) > 1
                pointsConsultedUnique = unique(edgesBetweenLevels(pointsConsulted, :), 'rows');
                if size(pointsConsultedUnique, 1) == 1 %If there is only one point that means there's a transition
                    p1 = pointsConsultedUnique(1, :);
                    p2 = uniqueFinalPoints(1, :);
                    p3 = edgesBetweenLevels(edge, :);
                    p4 = uniqueFinalPoints(2, :);
                    
                    t1Points = [t1Points; mean([p1; p2; p3; p4])];
                    t1Point = mean([p1; p2; p3; p4]);
                    
                    %Inserting t1 points in 4 edges
                    %Plane 0
                    [lia, locb] = ismember(edgesBetweenLevels, [p1; p2; p3; p4], 'rows');
                    p1Sites = find(locb == 1);
                    p2Sites = find(locb == 2);
                    p3Sites = find(locb == 3);
                    p4Sites = find(locb == 4); %useless
                    odd1 = 0;
                    odd2 = 0;
                    odd3 = 0;
                    odd4 = 0;
                    if size(p1Sites, 1) == size(p3Sites, 1) && mod(size(p1Sites, 1), 4) == 0
                        for pSite = 1:size(p1Sites, 1)
                            %point1 in p6
                            p2S = p2Sites(p1Sites(pSite) + 1 == p2Sites);
                            if size(p2S, 1) > 0 %It is in p2Sites
                                if odd1
                                    edgesBetweenLevelsAux(p1Sites(pSite) + 1, :) = t1Point;
                                    odd1 = 0;
                                else
                                    odd1 = 1;
                                    edgesBetweenLevelsAux(p1Sites(pSite), :) = t1Point;
                                end
                            else %it is in p4Sites
                                if odd2
                                    edgesBetweenLevelsAux(p1Sites(pSite) + 1, :) = t1Point;
                                    odd2 = 0;
                                else
                                    edgesBetweenLevelsAux(p1Sites(pSite), :) = t1Point;
                                    odd2 = 1;
                                end
                            end
                            %Other point in p6
                            p2S = p2Sites(p3Sites(pSite) + 1 == p2Sites);
                            if size(p2S, 1) > 0 %It is in p2Sites
                                if odd3
                                    edgesBetweenLevelsAux(p3Sites(pSite) + 1, :) = t1Point;
                                    odd3 = 0;
                                else
                                    odd3 = 1;
                                    edgesBetweenLevelsAux(p3Sites(pSite), :) = t1Point;
                                end
                            else %it is in p4Sites
                                if odd4
                                    edgesBetweenLevelsAux(p3Sites(pSite) + 1, :) = t1Point;
                                    odd4 = 0;
                                else
                                    edgesBetweenLevelsAux(p3Sites(pSite), :) = t1Point;
                                    odd4 = 1;
                                end
                            end
                        end
                    end
                end
            end
        end
        edge = edge + 2;
    end
    t1Points = unique(t1Points, 'rows');
end

