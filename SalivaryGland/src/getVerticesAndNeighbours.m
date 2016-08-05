function [ vertices, neighbours_vertices ] = getVerticesAndNeighbours( img )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    
    countVertices = 1;
    maxClass = max(img(:)) + 1;
    radio = 3;
    se = strel('square',radio);
    for row = 1:size(img, 1)
        for col = 1:size(img, 2)
            if img(row, col) == 0 %border of polygons
                imgAux = img;
                imgAux(row, col) = maxClass;
                BW2_dilate = imdilate(imgAux == maxClass, se);
                pixels_Neigh = BW2_dilate == 1;
                
                neighbours = unique(imgAux(pixels_Neigh));
                neighbours = neighbours(neighbours ~= maxClass & neighbours ~= 0);
                if size(neighbours, 1) > 2
                    vertices{countVertices} = [row, col];
                    neighbours_vertices{countVertices} = neighbours;
                    countVertices = countVertices + 1;
                end
            end
        end
    end
    vertices = vertices';
    vertices = vertcat(vertices{:});
    neighbours_vertices = horzcat(neighbours_vertices{:});
    neighbours_vertices = neighbours_vertices';
end