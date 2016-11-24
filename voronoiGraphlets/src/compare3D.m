function [ ] = compare3D( currentPath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    clearvars -except currentPath
    unifyDistances(currentPath);
    load('results\comparisons\EveryFile\maxLength5\AgainstHexagons\allDifferences.mat' );
    nameFiles = namesFinal;
    percentageOfHexagons = differenceWithRegularHexagon';
    load(strcat(currentPath, 'allDifferences.mat'))
    differenceWithRegularHexagon = differenceWithRegularHexagon';
    names = namesFinal;
    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '_', '-'), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, 'adjacencyMatrix', ''), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '-data', ''), names, 'UniformOutput', false);
    names = cellfun(@(x) x(1:end), names, 'UniformOutput', false);
    namesToCompare = cellfun(@(x) strrep(x, '-OnlyWeightedCells', ''), names, 'UniformOutput', false);
    namesToCompare = cellfun(@(x) strrep(x, '-OnlyNeighboursOfWeightedCells', ''), namesToCompare, 'UniformOutput', false);
    

    nameFiles = cellfun(@(x) strsplit(x, '/'), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) x{end}, nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) strrep(x, '_', '-'), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) strrep(x, 'adjacencyMatrix', ''), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) strrep(x, '-data', ''), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) x(1:end), nameFiles, 'UniformOutput', false);
    
    rightPercentages = zeros(1, size(names, 2));
    for numName = 1:size(nameFiles, 2)
        numFound = find(cellfun(@(x) isequal(nameFiles{numName}, x ), namesToCompare, 'UniformOutput', true) == 1);
        if size(numFound, 1) > 1
            error('MEEEEC');
        end
        if isempty(numFound) == 0
            rightPercentages(1, numFound) = percentageOfHexagons(numName);
%             rightPercentages(1, numFound) = points1Dimension(numName);
        else
            nameFiles{numName};
        end
    end
    percentageOfHexagons = rightPercentages;
    if size(percentageOfHexagons, 2) ~= size(differenceWithRegularHexagon, 1)
        error('No matrix coincidence on size');
    end
    if sum(percentageOfHexagons == 0) > 0
        error('Wrong percentages');
    end
    differenceRV = percentageOfHexagons;
    load('results\comparisons\EveryFile\percentageOfHexagons.mat');
    nameFiles = cellfun(@(x) strsplit(x, '\'), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) x{end}, nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) x(1:end-7), nameFiles, 'UniformOutput', false);
    nameFiles = cellfun(@(x) strrep(x, '_', '-'), nameFiles, 'UniformOutput', false);
    rightPercentages = zeros(1, size(names, 2));
    for numName = 1:size(nameFiles, 2)
        numFound = find(cellfun(@(x) isequal(nameFiles{numName}, x ), namesToCompare, 'UniformOutput', true) == 1);
        if size(numFound, 1) > 1
            error('MEEEEC');
        end
        if isempty(numFound) == 0
            rightPercentages(1, numFound) = percentageOfHexagons(numName);
%             rightPercentages(1, numFound) = points1Dimension(numName);
        else
            nameFiles{numName};
        end
    end
    percentageOfHexagons = rightPercentages;
    if size(percentageOfHexagons, 2) ~= size(differenceWithRegularHexagon, 1)
        error('No matrix coincidence on size');
    end
    if sum(percentageOfHexagons == 0) > 0
        error('Wrong percentages');
    end

 numberOfTypes = 17;
    colors = hsv(numberOfTypes);
    colors(1, :) = [0.0 0.2 0.0]; %BCA
    colors(2, :) = [1.0 0.4 0.0]; %Eye
    colors(3, :) = [0.0 0.4 0.8]; %cNT
    colors(4, :) = [0.0 0.6 0.0]; %dWL
    colors(5, :) = [0.8 0.0 0.0]; %dWP
    colors(6, :) = [0.8 0.8 0.8]; %voronoi
    colors(7, :) = [0.6 0.0 1.0]; %voronoiWeighted
    %colors(8, :) = [1.0 1.0 0.0]; %voronoiNoise
    colors(9, :) = [1.0 0.8 1.0]; %Case II
    colors(10, :) = [1.0 0.4 1.0]; %Case III
    colors(11, :) = [1.0 0.0 1.0]; %Case IV
    colors(12, :) = [0.6 0.6 1.0]; %dMWP
    colors(13, :) = [0.2 0.8 1.0]; %Atrophy Sim
    colors(15, :) = [0.0 0.0 0.0]; %Control Sim No Prol
    colors(14, :) = [0.4 0.0 0.0]; %Control Sim Prol
    colors(16, :) = [0.2 0.4 0.6]; %BNA
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);
    h = zeros(numberOfTypes);
    indices = [1:20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700];
    offSetGraysFont = 10;
    graysFont = gray(length(indices) + offSetGraysFont);
    %graysFont = graysFont(end:-1:1, :);
    
    for i = 1:size(names, 2)
        if isempty(strfind(names{i}, 'voronoiNoise')) == 0
            %             if isempty(strfind(names{i}, 'voronoiNoise-Image-10')) ~= 0
            nameDiagram = strsplit(names{i}, '-');
            h(8, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', graysFont (indices == str2num(nameDiagram{5}), :));
            hold on;
            
            %             end
%         elseif isempty(strfind(names{i}, 'imagen')) == 0
%             h(6, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(6, :));
%             hold on;
%             nameDiagram = strsplit(names{i}, '-');
%             t1 = text(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), nameDiagram(end));
%             t1.FontSize = 5;
%             t1.HorizontalAlignment = 'center';
%             t1.VerticalAlignment = 'middle';
%             t1.Color =  graysFont (find(indices == str2num(nameDiagram{end})) + offSetGraysFont, :);
        end
    end
    
    for i = 1:size(names, 2)
        if isempty(strfind(names{i}, 'omm')) == 0
            h(2, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(2, :));
%         elseif isempty(strfind(names{i}, 'BC')) == 0
%             h(1, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(1, :));
        elseif isempty(strfind(names{i}, 'cNT')) == 0
            h(3, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(3, :));
        elseif isempty(strfind(names{i}, 'dWL')) == 0
            h(4, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(4, :));
        elseif isempty(strfind(names{i}, 'dWP')) == 0
            h(5, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(5, :));
%         elseif isempty(strfind(names{i}, 'disk')) == 0 %voronoiWeighted
%             if isempty(strfind(names{i}, 'Neighbours'))
%                 h(7, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(7, :));
%             else
%                 h(17, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(7, :));
%             end
%             nameDiagram = strsplit(names{i}, '-');
%             t1 = text(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), nameDiagram(6));
%             t1.FontSize = 5;
%             t1.HorizontalAlignment = 'center';
%             t1.VerticalAlignment = 'middle';
        elseif isempty(strfind(names{i}, 'Case-III')) == 0
            h(10, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(10, :));
        elseif isempty(strfind(names{i}, 'Case-II')) == 0
            h(9, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(9, :));
        elseif isempty(strfind(names{i}, 'Case-IV')) == 0
            h(11, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(11, :));
        elseif isempty(strfind(names{i}, 'dMWP')) == 0
            h(12, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(12, :));
%         elseif isempty(strfind(names{i}, 'Atrophy-Sim')) == 0
%             h(13, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(13, :));
        elseif isempty(strfind(names{i}, 'Control-Sim-Prol')) == 0
            h(14, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(14, :));
%         elseif isempty(strfind(names{i}, 'Control-Sim-no-Prol')) == 0
%             h(15, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(15, :));
%         elseif isempty(strfind(names{i}, 'BNA')) == 0
%             h(16, :) = scatter3(differenceWithRegularHexagon(i), differenceRV(i) ,percentageOfHexagons(i), 'markerEdgeColor', colors(16, :));
%         else
%             names{i};
        end
    end
    
    %'BNA' remaining
    newNames = {'BCA', 'Eye', 'cNT', 'dWL', 'dWP', 'Voronoi', 'Voronoi weighted - Cancer cells', 'Voronoi Noise', 'Case II', 'Case III', 'Case IV', 'dMWP', 'Atrophy', 'Control Proliferative', 'Control No Proliferative', 'BNA', 'Voronoi weighted - Neighbours of cancer cells'};
    hlegend1 = legend(h(h(:, 1) > 0, 1), newNames(h(:, 1) > 0)', 'Location', 'best');
    
    xlabel('Graphlet degree distance-hexagons (GDDH)');
    ylabel('Graphlet degree distance random voronoi (GDDRV)');
    auxLim = xlim;
    xlim([0 auxLim(2)])
    auxLim = ylim;
    ylim([0 auxLim(2)])
    zlim([0 100]);

%     export_fig(h1, 'differenceGDDRV_GDDH', '-pdf', '-r300');
%     export_fig(h1, 'differenceGDDRV_GDDH----OpenGl', '-pdf', '-r300', '-opengl');
%     export_fig(h1, 'differenceGDDRV_GDDH----OpenGl2', '-pdf', '-r400', '-opengl');

end

