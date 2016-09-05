function [ verticesToVisualize ] = paintPolyhedron( neighboursVerticesV, verticesV, classesToVisualize, classToVisualize)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    [x, ~] = find(neighboursVerticesV == classesToVisualize(classToVisualize));
    vertices = verticesV(unique(x), :);
    verticesToVisualize = [vertices, ones(size(vertices, 1), 1)*100];
    verticesToVisualize = verticesToVisualize(verticesToVisualize(:, 2) > 512 & verticesToVisualize(:, 2) < 1024, :);
end

