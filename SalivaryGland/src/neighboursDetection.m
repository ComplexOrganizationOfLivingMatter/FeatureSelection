function [ Neighbour_cell, N_Neighbour_cell ] = neighboursDetection( Img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   
    radio=2;
    for cell=1 : max(Img(:))
        BW2 = bwperim(Img == cell);
        [~,~] = find(BW2 == 1);
        se = strel('disk',radio);
        BW2_dilate = imdilate(BW2,se);
        pixels_Neigh = BW2_dilate == 1;
        Neighbour = unique(Img(pixels_Neigh));
        Neighbour = Neighbour(Neighbour ~= 0 & Neighbour ~= cell);
        Neighbour_cell{cell} = Neighbour;
        N_Neighbour_cell(cell) = length(Neighbour_cell{cell});
    end
end

