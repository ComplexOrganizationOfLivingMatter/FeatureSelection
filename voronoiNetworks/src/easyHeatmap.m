function [ output_args ] = easyHeatmap( distanceMatrix, names, outputFile, filter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
%     names = cellfun(@(x) strsplit(x, '/'), names, 'UniformOutput', false);
%     names = cellfun(@(x) x{end}, names, 'UniformOutput', false);
%     names
    sortedNumbers = [1, 12, 14, 15, 16, 17, 18, 19, 20, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13];
    %names = names';
    %[newNamesSorted, indices] = sort(names);
    
    %filteredRows = cellfun(@(x) size(strfind(x, filter), 1) > 0, newNamesSorted);
    %newNamesSorted = {newNamesSorted{filteredRows}};
    %indices = indices(filteredRows);
    
    heatmap = (distanceMatrix(:, sortedNumbers)/max(distanceMatrix(:)))*64;
    
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);
    image(heatmap);
    %colormap('gray');
    %colormap('pink');
    axis image
    colorbar
    
    title(outputFile);
    %names = cellfun(@(x) x(16:end-5), names, 'UniformOutput', false);
    set(gca,'YTick', [1:size(names,2)], 'YTickLabel', names);
    set(gca,'XTick', [1:size(sortedNumbers,2)], 'XTickLabel', 1:20);

    namefile = strcat('heatmapGraphlets_', outputFile);
    %saveas(h1, namefile{:});
    export_fig(h1, namefile, '-png', '-a4', '-m1.5');
end

