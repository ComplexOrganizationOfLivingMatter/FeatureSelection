function [ verticesToVisualize ] = paintPolyhedron( neighboursVerticesV, verticesV, classesToVisualize, classToVisualize)
%PAINTPOLYHEDRON Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    [x, ~] = find(neighboursVerticesV == classesToVisualize(classToVisualize));
    vertices = verticesV(unique(x), :);
    verticesToVisualize(:, 3) = vertices(:, 3) * 100;
    verticesToVisualize = verticesToVisualize(verticesToVisualize(:, 2) > 512 & verticesToVisualize(:, 2) < 1024, :);
end

