function [ ] = paintAlphaShape( verticesToVisualize3, verticesToVisualize, classToVisualize)
%PAINTALPHASHAPE Summary of this function goes here
%   Detailed explanation goes here
%
%   Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez
    p = alphaShape([verticesToVisualize3; verticesToVisualize]);
    p.Alpha
    p.Alpha = 350;
    h = plot(p);
    h.FaceAlpha = .25;
    if mod(classToVisualize, 4) == 0
        h.FaceColor = [1 1 0];
    elseif mod(classToVisualize, 4) == 1
        h.FaceColor = [1 0 1];
    elseif mod(classToVisualize, 4) == 2
        h.FaceColor = [.25 .25 .25];
    else
        h.FaceColor = [0 1 1];
    end
end

