function [ edgesMidPlane ] = remove3Cycle( midPlanePoints, edgesMidPlane )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %Removing cycles of 3 vertices
    midPlanePoint = 1;
    while midPlanePoint <= size(midPlanePoints, 1)%First edge
        isOver = 0;
        duplicatedEdges = find(all(bsxfun(@eq, midPlanePoints(midPlanePoint, :), edgesMidPlane(:, :)), 2));
        
        for dupl = 1:size(duplicatedEdges, 1) %Second edge
            if mod(duplicatedEdges(dupl), 2) == 0
                midCycleEdge = duplicatedEdges(dupl) - 1;
                endOfCycleEdges = find(all(bsxfun(@eq, edgesMidPlane(duplicatedEdges(dupl) - 1, :), edgesMidPlane(:, :)), 2));
            else
                midCycleEdge = duplicatedEdges(dupl) + 1;
                endOfCycleEdges = find(all(bsxfun(@eq, edgesMidPlane(duplicatedEdges(dupl) + 1, :), edgesMidPlane(:, :)), 2));
            end
                
            for cycleEdge = 1:size(endOfCycleEdges, 1) %third edge
                if mod(endOfCycleEdges(cycleEdge), 2) ~= mod(duplicatedEdges(dupl), 2)
                    if mod(endOfCycleEdges(cycleEdge), 2) == 0
                        indexCycleEdge = endOfCycleEdges(cycleEdge) - 1;
                    else
                        indexCycleEdge = endOfCycleEdges(cycleEdge) + 1;
                    end
                    if ismember(edgesMidPlane(indexCycleEdge, :), midPlanePoints(midPlanePoint, :), 'rows') == 0 %Is not the same point
                        initOfCycleEdges = find(all(bsxfun(@eq, edgesMidPlane(indexCycleEdge, :), edgesMidPlane(:, :)), 2));
                        for initEdge = 1:size(initOfCycleEdges, 1) %Again the first one
                            if mod(endOfCycleEdges(cycleEdge), 2) ~= mod(initOfCycleEdges(initEdge), 2)
                                if mod(initOfCycleEdges(initEdge), 2) == 0
                                    indexInitCycleEdge = initOfCycleEdges(initEdge) - 1;
                                else
                                    indexInitCycleEdge = initOfCycleEdges(initEdge) + 1;
                                end
                                if ismember(edgesMidPlane(indexInitCycleEdge, :), edgesMidPlane(indexCycleEdge, :), 'rows') == 0 %Is not the same point
                                    if ismember(edgesMidPlane(indexInitCycleEdge, :), midPlanePoints(midPlanePoint, :), 'rows') == 1 %Closes the cycle?
                                       %Then remove the farer one
                                       distance1 = distancesBetweenEdges([midPlanePoints(midPlanePoint, :); edgesMidPlane(indexCycleEdge, :)]);
                                       distance2 = distancesBetweenEdges([edgesMidPlane(midCycleEdge, :); edgesMidPlane(indexCycleEdge, :)]);
                                       distance3 = distancesBetweenEdges([edgesMidPlane(midCycleEdge, :); midPlanePoints(midPlanePoint, :)]);
                                       
                                       if distance1 > distance2
                                           if distance1 > distance3
                                               edgesMidPlane([indexInitCycleEdge; indexCycleEdge], :) = [];
                                           else
                                               edgesMidPlane([midCycleEdge; indexInitCycleEdge], :) = [];
                                           end
                                       else
                                          if distance2 > distance3
                                              edgesMidPlane([midCycleEdge; indexCycleEdge], :) = [];
                                          else
                                              edgesMidPlane([midCycleEdge; indexInitCycleEdge], :) = [];
                                          end
                                       end
                                       
                                       midPlanePoint = midPlanePoint - 1;
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
            if isOver
                break
            end
        end
        midPlanePoint = midPlanePoint + 1;
    end

end

