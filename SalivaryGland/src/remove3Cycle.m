function [ edgesMidPlane ] = remove3Cycle( midPlanePoints, edgesMidPlane )
%REMOVE3CYCLE Check if there is a cycle within the mid plane and remove it if necessary
%   We look for duplicated wrong edges, which will lead to form wrong convex polygons
%   at the mid plane image. We removed then if they form a cycle, getting only the 
%   closest edges, minimizing the distance between edges
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

    %Removing cycles of 3 vertices
    midPlanePoint = 1;
    while midPlanePoint <= size(midPlanePoints, 1)%First vertex
      isOver = 0;
        %indices of the edges connected to midPlanePoint
        duplicatedEdges = find(all(bsxfun(@eq, midPlanePoints(midPlanePoint, :), edgesMidPlane(:, :)), 2));
        
        for dupl = 1:size(duplicatedEdges, 1) %Second vertex
          %Whether the vertex is at the end or the beggining of the edge
          if mod(duplicatedEdges(dupl), 2) == 0
            %We get other vertex
            midCycleEdge = duplicatedEdges(dupl) - 1;
            endOfCycleEdges = find(all(bsxfun(@eq, edgesMidPlane(duplicatedEdges(dupl) - 1, :), edgesMidPlane(:, :)), 2));
          else
            %We get other vertex
            midCycleEdge = duplicatedEdges(dupl) + 1;
            endOfCycleEdges = find(all(bsxfun(@eq, edgesMidPlane(duplicatedEdges(dupl) + 1, :), edgesMidPlane(:, :)), 2));
          end

            for cycleEdge = 1:size(endOfCycleEdges, 1) %third vertex
              %if it is the other part of the edges, not 
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

                                        %%% finally we remove the longest edge. Thus, we test the three possible edges. 
                                        %%% One will be the discarded one.
                                       distance1 = distancesBetweenEdges([edgesMidPlane(duplicatedEdges(dupl), :); edgesMidPlane(midCycleEdge, :)]); %First edge
                                       distance3 = distancesBetweenEdges([edgesMidPlane(initOfCycleEdges(initEdge), :); edgesMidPlane(indexInitCycleEdge, :)]); %Third edge
                                       distance2 = distancesBetweenEdges([edgesMidPlane(endOfCycleEdges(cycleEdge), :); edgesMidPlane(indexCycleEdge, :)]); %Second edge
                                       
                                       %%% Check which edge is the longest one.
                                       if distance1 > distance2
                                         if distance1 > distance3
                                           edgesMidPlane([duplicatedEdges(dupl); midCycleEdge], :) = [];
                                         else
                                           edgesMidPlane([initOfCycleEdges(initEdge); indexInitCycleEdge], :) = [];
                                         end
                                       else
                                        if distance2 > distance3
                                          edgesMidPlane([endOfCycleEdges(cycleEdge); indexCycleEdge], :) = [];
                                        else
                                          edgesMidPlane([initOfCycleEdges(initEdge); indexInitCycleEdge], :) = [];
                                        end
                                      end

                                      %To check again the same point
                                      midPlanePoint = midPlanePoint - 1;
                                       %we found a duplicated edge, and we have to check if the same edge has more.
                                       isOver = 1;
                                       break
                                     end
                                   end
                                 end
                               end
                        %we found a duplicated edge, and we have to check if the same edge has more.
                        if isOver 
                          break
                        end
                      end
                    end
                  end
            %we found a duplicated edge, and we have to check if the same edge has more.
            if isOver
              break
            end
          end
          midPlanePoint = midPlanePoint + 1;
        end


      end

