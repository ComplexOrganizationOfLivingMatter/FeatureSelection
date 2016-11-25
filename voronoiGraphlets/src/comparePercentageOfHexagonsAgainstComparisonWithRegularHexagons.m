function [ ] = comparePercentageOfHexagonsAgainstComparisonWithRegularHexagons( currentPath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    set(0,'DefaultAxesFontName', 'Helvetica-Narrow')
    clearvars -except currentPath
    unifyDistances(currentPath);
%     load('results\comparisons\EveryFile\maxLength5\AgainstHexagons\allDifferences.mat' );
%     nameFiles = namesFinal;
%     percentageOfHexagons = differenceWithRegularHexagon';
    load(strcat(currentPath, 'allDifferences.mat'))
    differenceWithRegularHexagonToAppend = differenceWithRegularHexagon';
    namesToAppend = namesFinal;
    
    %total graphlets
    totalGraphletsPath = strrep(currentPath, 'EveryFile', 'Total');
    unifyDistances(totalGraphletsPath);
    load(strcat(totalGraphletsPath, 'allDifferences.mat'))
    differenceWithRegularHexagon = vertcat(differenceWithRegularHexagon', differenceWithRegularHexagonToAppend);
    names = {namesFinal{:}, namesToAppend{:}};
    if isempty(strfind(currentPath, 'maxLength5'))
        load('results\comparisons\EveryFile\percentageOfHexagons-Weighted_maxLength4.mat')
    else
        load('results\comparisons\EveryFile\percentageOfHexagons-Weighted_maxLength5.mat')
    end
    names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
    names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '_', '-'), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, 'adjacencyMatrix', ''), names, 'UniformOutput', false);
    names = cellfun(@(x) strrep(x, '-data', ''), names, 'UniformOutput', false);
    names = cellfun(@(x) x(1:end), names, 'UniformOutput', false);
    namesToCompare = cellfun(@(x) strrep(x, '-OnlyWeightedCells', ''), names, 'UniformOutput', false);
    namesToCompare = cellfun(@(x) strrep(x, '-OnlyNeighboursOfWeightedCells', ''), namesToCompare, 'UniformOutput', false);
    
    %% namefiles in case is GDDRV vs GDDRH
%     nameFiles = cellfun(@(x) strsplit(x, '/'), nameFiles, 'UniformOutput', false);
%     nameFiles = cellfun(@(x) x{end}, nameFiles, 'UniformOutput', false);
%     nameFiles = cellfun(@(x) strrep(x, '_', '-'), nameFiles, 'UniformOutput', false);
%     nameFiles = cellfun(@(x) strrep(x, 'adjacencyMatrix', ''), nameFiles, 'UniformOutput', false);
%     nameFiles = cellfun(@(x) strrep(x, '-data', ''), nameFiles, 'UniformOutput', false);
%     nameFiles = cellfun(@(x) x(1:end), nameFiles, 'UniformOutput', false);

    %% namefiles otherwise
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
    colors(7, :) = [0.6 0.0 1.0]; %voronoiWeighted Cancer
    colors(8, :) = [0.6 0.0 0.8]; %voronoiWeighted Neighbours
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
    hold on;
    indices = [1:20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700];
    offSetGraysFont = 10;
    graysFont = gray(length(indices) + offSetGraysFont);
    %graysFont = graysFont(end:-1:1, :);
    
    for i = 1:size(names, 2)
        if isempty(strfind(names{i}, 'totalGraphlets'))
            if isempty(strfind(names{i}, 'voronoiNoise')) == 0
                %             if isempty(strfind(names{i}, 'voronoiNoise-Image-10')) ~= 0
                nameDiagram = strsplit(names{i}, '-');
                h(8, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', graysFont (indices == str2num(nameDiagram{5}), :));
                
                %             t1 = text(differenceWithRegularHexagon(i),percentageOfHexagons(i), nameDiagram(5));
                %             t1.FontSize = 5;
                %             t1.HorizontalAlignment = 'center';
                %             t1.VerticalAlignment = 'middle';
                %             t1.Color =  graysFont (find(indices == str2num(nameDiagram{5})), :);
                %         elseif isempty(strfind(names{i}, 'imagen')) == 0
                %             h(6, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(6, :));
                %             nameDiagram = strsplit(names{i}, '-');
                %             t1 = text(differenceWithRegularHexagon(i),percentageOfHexagons(i), nameDiagram(end));
                % %             t1.FontSize = 5;
                % %             t1.HorizontalAlignment = 'center';
                % %             t1.VerticalAlignment = 'middle';
                % %             t1.Color =  graysFont (find(indices == str2num(nameDiagram{end})), :);
            end
        end
    end
    
    for i = 1:size(names, 2)
        if isempty(strfind(names{i}, 'totalGraphlets'))
            if isempty(strfind(names{i}, 'omm')) == 0
                h(2, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(2, :));
    %         elseif isempty(strfind(names{i}, 'BC')) == 0
    %             h(1, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(1, :));
            elseif isempty(strfind(names{i}, 'cNT')) == 0
                h(3, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(3, :));
            elseif isempty(strfind(names{i}, 'dWL')) == 0
                h(4, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(4, :));
            elseif isempty(strfind(names{i}, 'dWP')) == 0
                h(5, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(5, :));
            elseif isempty(strfind(names{i}, 'disk')) == 0 %voronoiWeighted
                if isempty(strfind(names{i}, 'Neighbours'))
                    h(7, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(7, :));
                else
                    h(17, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(8, :));
                end
    %             nameDiagram = strsplit(names{i}, '-');
    %             t1 = text(differenceWithRegularHexagon(i),percentageOfHexagons(i), nameDiagram(6));
    %             t1.FontSize = 5;
    %             t1.HorizontalAlignment = 'center';
    %             t1.VerticalAlignment = 'middle';
            elseif isempty(strfind(names{i}, 'Case-III')) == 0
                h(10, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(10, :));
            elseif isempty(strfind(names{i}, 'Case-II')) == 0
                h(9, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(9, :));
            elseif isempty(strfind(names{i}, 'Case-IV')) == 0
                h(11, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(11, :));
            elseif isempty(strfind(names{i}, 'dMWP')) == 0
                h(12, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(12, :));
    %         elseif isempty(strfind(names{i}, 'Atrophy-Sim')) == 0
    %             h(13, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(13, :));
            elseif isempty(strfind(names{i}, 'Control-Sim-Prol')) == 0
                h(14, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(14, :));
    %         elseif isempty(strfind(names{i}, 'Control-Sim-no-Prol')) == 0
    %             h(15, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(15, :));
    %         elseif isempty(strfind(names{i}, 'BNA')) == 0
    %             h(16, :) = plot(differenceWithRegularHexagon(i), percentageOfHexagons(i), 'o', 'color', colors(16, :));
    %         else
    %             names{i};
            end
        end
    end
    
    %%Total graphlets (or means)
    indicesTotalGraphlets = cellfun(@(x) isempty(strfind(x, 'totalGraphlets')) == 0, names);
    namesTotalGraphlets = names(indicesTotalGraphlets);
    percentageOfHexagonsTotalGraphlets = percentageOfHexagons(indicesTotalGraphlets);
    differenceWithRegularHexagonTotalGraphlets = differenceWithRegularHexagon(indicesTotalGraphlets);
    for i = 1:size(namesTotalGraphlets, 2)
        if isempty(strfind(namesTotalGraphlets{i}, 'totalGraphlets')) == 0
            if isempty(strfind(namesTotalGraphlets{i}, 'voronoiNoise')) == 0
                %             if isempty(strfind(names{i}, 'voronoiNoise-Image-10')) ~= 0
                nameDiagram = strsplit(namesTotalGraphlets{i}, '-');
                meanImages = cellfun(@(x) isempty(strfind(x, 'voronoiNoise')) == 0 & isempty(strfind(x, nameDiagram{2})) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
                h(8, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', graysFont (indices == str2num(nameDiagram{2}), :), 'MarkerFaceColor', graysFont (indices == str2num(nameDiagram{2}), :));
            end
        end
    end
    
    for i = 1:size(namesTotalGraphlets, 2)
        if isempty(strfind(namesTotalGraphlets{i}, 'omm')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'omm')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(2, :) = plot(mean(differenceWithRegularHexagon(meanImages)), 28.12, 'o', 'color', colors(2, :), 'MarkerFaceColor', colors(2, :));
            %         elseif isempty(strfind(names{i}, 'BC')) == 0
            %             h(1, :) = plot(differenceWithRegularHexagonTotalGraphlets, percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(1, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'cNT')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'cNT')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(3, :) = plot(mean(differenceWithRegularHexagon(meanImages)), 28.30, 'o', 'color', colors(3, :), 'MarkerFaceColor', colors(3, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'dWL')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'dWL')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(4, :) = plot(mean(differenceWithRegularHexagon(meanImages)),44.37, 'o', 'color', colors(4, :), 'MarkerFaceColor', colors(4, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'dWP')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'dWP')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(5, :) = plot(mean(differenceWithRegularHexagon(meanImages)), 48.10, 'o', 'color', colors(5, :), 'MarkerFaceColor', colors(5, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'disk')) == 0 %voronoiWeighted
            nameDiagram = strsplit(namesTotalGraphlets{i}, '-');
            if isempty(strfind(namesTotalGraphlets{i}, 'Neighbours'))
                meanImages = cellfun(@(x) isempty(strfind(x, 'disk')) == 0 & isempty(strfind(x, nameDiagram{3})) == 0 & isempty(strfind(x, 'Neighbours')) & isempty(strfind(x, 'totalGraphlets')), names);
                h(7, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(7, :), 'MarkerFaceColor', colors(7, :));
            else
                meanImages = cellfun(@(x) isempty(strfind(x, 'disk')) == 0 & isempty(strfind(x, nameDiagram{3})) == 0 & isempty(strfind(x, 'Neighbours')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
                h(17, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(8, :), 'MarkerFaceColor', colors(8, :));
            end
        elseif isempty(strfind(namesTotalGraphlets{i}, 'Case-III')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'Case-III')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(10, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(10, :), 'MarkerFaceColor', colors(10, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'Case-II')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'Case-II')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(9, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(9, :), 'MarkerFaceColor', colors(9, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'Case-IV')) == 0
            eanImages = cellfun(@(x) isempty(strfind(x, 'Case-IV')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(11, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(11, :), 'MarkerFaceColor', colors(11, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'dMWP')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'dMWP')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(12, :) = plot(mean(differenceWithRegularHexagon(meanImages)), 35.77, 'o', 'color', colors(12, :), 'MarkerFaceColor', colors(12, :));
%             elseif isempty(strfind(namesTotalGraphlets{i}, 'Atrophy-Sim')) == 0
%                 h(13, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(13, :), 'MarkerFaceColor', colors(13, :));
        elseif isempty(strfind(namesTotalGraphlets{i}, 'Control-Sim-Prol')) == 0
            meanImages = cellfun(@(x) isempty(strfind(x, 'Control-Sim-Prol')) == 0 & isempty(strfind(x, 'totalGraphlets')), names);
            h(14, :) = plot(mean(differenceWithRegularHexagon(meanImages)), percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(14, :), 'MarkerFaceColor', colors(14, :));
%             elseif isempty(strfind(namesTotalGraphlets{i}, 'Control-Sim-no-Prol')) == 0
%                 h(15, :) = plot(differenceWithRegularHexagonTotalGraphlets, percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(15, :), 'MarkerFaceColor', colors(15, :));
%             elseif isempty(strfind(namesTotalGraphlets{i}, 'BNA')) == 0
%                 h(16, :) = plot(differenceWithRegularHexagonTotalGraphlets, percentageOfHexagonsTotalGraphlets(i), 'o', 'color', colors(16, :), 'MarkerFaceColor', colors(16, :));
        else
            names{i};
        end
    end
    
    %'BNA' remaining
    newNames = {'BCA', 'Eye', 'cNT', 'dWL', 'dWP', 'Voronoi', 'Voronoi weighted - Cancer cells', 'Voronoi Noise', 'Case II', 'Case III', 'Case IV', 'dMWP', 'Atrophy', 'Control Proliferative', 'Control No Proliferative', 'BNA', 'Voronoi weighted - Neighbours of cancer cells'};
    hlegend1 = legend(h(h(:, 1) > 0, 1), newNames(h(:, 1) > 0)', 'Location', 'best');
    
    
    auxLim = xlim;
    xlim([0 auxLim(2)])
    auxLim = ylim;
    ylim([0 100])
    %ylim([0 auxLim(2)])
    
    ylabel('Percentage of hexagons', 'FontWeight', 'bold');
    
    if isempty(strfind(currentPath, 'Voronoi1')) == 0
        xlabel('Graphlet degree distance random voronoi (GDDRV)', 'FontWeight', 'bold');
        export_fig(strcat('GDDRV_PercentageOfHexagons', '-', strjoin(newNames(h(:, 1) > 0), '_')), '-pdf', '-r300', '-opengl');
    else
        xlabel('Graphlet degree distance-hexagons (GDDH)', 'FontWeight', 'bold');
        export_fig(strcat('GDDH_PercentageOfHexagons', '-', strjoin(newNames(h(:, 1) > 0), '_')), '-pdf', '-r300', '-opengl');
    end

    %% GDDRV vs GDDH
%     xlabel('Graphlet degree distance random voronoi (GDDRV)', 'FontWeight', 'bold');
%     ylabel('Graphlet degree distance-hexagons (GDDH)', 'FontWeight', 'bold');
%     export_fig(strcat('differenceGDDRV_GDDH', '-', strjoin(newNames(h(:, 1) > 0), '_')), '-pdf', '-r300', '-opengl');

    %export_fig(h1, 'differenceGDDRV_GDDH', '-pdf', '-r300');
    
    %export_fig(h1, 'differenceGDDRV_GDDH----OpenGl2', '-pdf', '-r400', '-opengl');

end

