function [ ] = comparePercentageOfHexagonsAgainstComparisonWithRegularHexagons(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    analyzeGraphletDistances('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\comparisons\EveryFile\maxLength5');
    load('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\comparisons\EveryFile\maxLength5\distanceMatrixMeanGCDDA.mat');
    differenceWithRegularHexagon = distanceMatrix(22,:);
    differenceWithRegularHexagon = differenceWithRegularHexagon(differenceWithRegularHexagon > 0);
    names = {names(distanceMatrix(22, :) ~= distanceMatrix(22, 22))};
    names = names{1};
    save('differenceWithRegularHexagon.mat', 'differenceWithRegularHexagon', 'names');
    getPercentageOfHexagons('E:\Pablo\PhD-miscelanious\voronoiGraphlets\results\graphletResultsFiltered\Original\');

    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '_', '-'), names, 'UniformOutput', false);
    %names = cellfun(@(x) x(16:end-5), names, 'UniformOutput', false);

    nameOfTypes = 13;
    colors = hsv(nameOfTypes);
    colors(1, :) = [0.0 0.2 0.0]; %BCA
    colors(2, :) = [1.0 0.4 0.0]; %Eye
    colors(3, :) = [0.0 0.4 0.8]; %cNT
    colors(4, :) = [0.0 0.6 0.0]; %dWL
    colors(5, :) = [0.8 0.0 0.0]; %dWP
    colors(6, :) = [0.8 0.8 0.8]; %voronoi
    colors(7, :) = [0.6 0.0 1.0]; %voronoiWeighted
    colors(8, :) = [1.0 1.0 0.0]; %voronoiNoise
    colors(9, :) = [0.2 0.4 0.6]; %BNA
    colors(10, :) = [0.8 0.8 0.8]; %Case II
    colors(11, :) = [1.0 0.6 1.0]; %Case III
    colors(12, :) = [1.0 0.2 1.0]; %Case IV
    colors(13, :) = [0.8 0.6 1.0]; %dMWP
    colors(14, :) = [0.2 0.8 1.0]; %Atrophy Sim
    colors(15, :) = [0.0 0.0 0.0]; %Control Sim Prol
    colors(15, :) = [0.4 0.0 0.0]; %Control Sim No Prol
    h1 = figure;
    h = zeros(size(nameOfTypes, 1));
    hold on;
    for i = 1:size(names, 1)
        if isempty(strfind(names{i}, 'BC')) == 0
            h(1, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(1, :), 'MarkerFaceColor', colors(1, :));
        elseif isempty(strfind(names{i}, 'omm')) == 0
            h(2, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(2, :), 'MarkerFaceColor', colors(2, :));
        elseif isempty(strfind(names{i}, 'cNT')) == 0
            h(3, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(3, :), 'MarkerFaceColor', colors(3, :));
        elseif isempty(strfind(names{i}, 'dWL')) == 0
            h(4, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(4, :), 'MarkerFaceColor', colors(4, :));
        elseif isempty(strfind(names{i}, 'dWP')) == 0
            h(5, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(5, :), 'MarkerFaceColor', colors(5, :));
        elseif isempty(strfind(names{i}, 'cols')) == 0 %voronoiWeighted
            h(7, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(7, :), 'MarkerFaceColor', colors(7, :));
        elseif isempty(strfind(names{i}, 'voronoiNoise')) == 0
            h(8, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(8, :), 'MarkerFaceColor', colors(8, :));
        elseif isempty(strfind(names{i}, 'BNA')) == 0
            h(9, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(9, :), 'MarkerFaceColor', colors(9, :));
        elseif isempty(strfind(names{i}, 'Case II')) == 0
            h(10, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(10, :), 'MarkerFaceColor', colors(10, :));
        elseif isempty(strfind(names{i}, 'Case III')) == 0
            h(11, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(11, :), 'MarkerFaceColor', colors(11, :));
        elseif isempty(strfind(names{i}, 'dMWP')) == 0
            h(12, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(12, :), 'MarkerFaceColor', colors(12, :));
        elseif isempty(strfind(names{i}, 'Atrophy Sim')) == 0
            h(13, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(13, :), 'MarkerFaceColor', colors(13, :));
        elseif isempty(strfind(names{i}, 'Control Sim Prol')) == 0
            h(14, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(14, :));
        elseif isempty(strfind(names{i}, 'Control Sim No Prol')) == 0
            h(15, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(15, :));
        elseif isempty(strfind(names{i}, 'Diagrama')) == 0
            h(6, :) = plot(differenceWithRegularHexagon(:, i), percentageOfHexagons(:, i), 'o', 'color', colors(6, :));
            nameDiagram = strsplit(names{i}, '-');
            t1 = text(differenceWithRegularHexagon(:, i),percentageOfHexagons(:, i), nameDiagram(end));
            t1.FontSize = 5;
            t1.HorizontalAlignment = 'center';
            t1.VerticalAlignment = 'bottom';
        end
    end

    newNames = {'BCA', 'Eye', 'cNT', 'dWL', 'dWP'};
    newNames{end+1} = 'Voronoi';
    hlegend1 = legend(h(:,1), newNames');
    title('Percentage of hexagons against graphlets difference with hexagonal tesselation');
    xlabel('Graphlets value comparison');
    ylabel('Percentage of hexagons');

    export_fig(h1, 'differenceGraphletsHexagonalTesselationAllFiles', '-png', '-a4', '-m1.5');

end

