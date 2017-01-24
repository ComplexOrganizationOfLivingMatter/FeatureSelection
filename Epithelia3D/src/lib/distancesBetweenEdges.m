function [ distances ] = distancesBetweenEdges( edges )
%DISTANCESBETWEENEDGES Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    distances = zeros(size(edges, 1)/2, 1);
    i = 1;
    while i <= size(edges, 1);
        distances((i+1)/2) = sqrt((edges(i, 1) - edges(i+1, 1))^2 + (edges(i, 2) - edges(i+1, 2))^2 + (edges(i, 3) - edges(i+1, 3))^2);
        i = i + 2;
    end

end

