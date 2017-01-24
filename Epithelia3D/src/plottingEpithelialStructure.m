function [ ] = plottingEpithelialStructure( voronoiClass, voronoiNoise, verticesV, verticesVNoise, edgesBetweenLevels, verticesVAdded, verticesVNoiseAdded, classesToVisualize, t1Points, edgesMidPlane, midPlaneImage)
%PLOTTINGEPITHELIALSTRUCTURE Plot in a figure how a voronoi and a voronoi noise form a 3D structure
%   We plot in a 3 dimensional space: the voronoi image at plane z = 6 and the voronoi noise at plane z = 0. 
%   Also, we paint the auto-generated middle plane from these two planes. We could paint the edges between the planes
%   ,as well as, vertices of the polygons of each plane.
%   The plot will be exported into a .fig file.
%   To open this file, you should run something like:
%       openfig('image.fig', 'visible')
%
%   Developed by Pablo Vicente-Munuera and Pedro Gómez-Gálvez

    ax = figure(1); 
    set(ax, 'visible', 'off')
    %-------------- Image 1 -------------------%
%     
    zAx = 6;
    paintImageAtPlaneZ(voronoiClass, zAx, classesToVisualize);
    
    hold on;
    
    %-------------- Image 2 -------------------%
    zAx = 0;
    paintImageAtPlaneZ(voronoiNoise, zAx, classesToVisualize);
     
    %----------- mid Plane --------------------%
    
    zAx = 3;
    paintImageAtPlaneZ(midPlaneImage, zAx, classesToVisualize);
    
     
    %------------ edges and points ---------------%
    numRow = 1;
    while numRow < size(edgesBetweenLevels,1)
        plot3(edgesBetweenLevels(numRow:numRow+1,2), edgesBetweenLevels(numRow:numRow+1,1), edgesBetweenLevels(numRow:numRow+1,3), 'LineWidth', 2);
        numRow = numRow + 2;
    end
    
    numRow = 1;
    while numRow < size(edgesMidPlane, 1)
       plot3(edgesMidPlane(numRow:numRow+1,2), edgesMidPlane(numRow:numRow+1,1), edgesMidPlane(numRow:numRow+1,3), 'LineWidth', 2, 'color', 'black');
       numRow = numRow + 2;
    end
    
%     numRow = 1;
%     while numRow < size(t1Points, 1)
%         plot3(t1Points(numRow, 2), t1Points(numRow, 1), t1Points(numRow, 3), 'o');
%         numRow = numRow + 1;
%     end
    

%     missingVerticesNum = find(verticesVAdded == 0);
%     missingVertices = verticesV(missingVerticesNum, :);
% 
%     for i = 1:size(missingVertices, 1)
%         plot3(missingVertices(i, 2), missingVertices(i, 1), 6, 'r*');
%     end
% 
%     missingVerticesNum = find(verticesVNoiseAdded == 0);
%     missingVertices = verticesVNoise(missingVerticesNum, :);
% 
%     for i = 1:size(missingVertices, 1)
%         plot3(missingVertices(i, 2), missingVertices(i, 1), 0, 'r*');
%     end

    alpha(0.3);
    axis([513 1024 0 512])
    colormap colorcube

    hold off;

end

