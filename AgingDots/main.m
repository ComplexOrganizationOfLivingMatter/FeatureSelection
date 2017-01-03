%% Developed by Pablo Vicente-Munuera and Pedro Gomez-Galvez

files12Months = dir('results\distanceMatrix\12-*');
nodes12Months = [];
for indexFile = 1:size(files12Months, 1)
    load(strcat('results\distanceMatrix\', files12Months(indexFile).name));
    nodes12Months(end+1) = size(distanceMatrix, 1);
end
mean12Months = round(mean(nodes12Months));
files18Months = dir('results\distanceMatrix\18-*');
nodes18Months = [];
for indexFile = 1:size(files18Months, 1)
    load(strcat('results\distanceMatrix\', files18Months(indexFile).name));
    nodes18Months(end+1) = size(distanceMatrix, 1);
end
mean18Months = round(mean(nodes18Months));

files3Months = dir('results\sortingAlgorithm\OnlyIter1\sorting_3-*');
for indexFile = 1:size(files3Months, 1)
    load(strcat('results\sortingAlgorithm\OnlyIter1\', files3Months(indexFile).name));
    adjacencyMatrix(adjacencyMatrix ~= 0) = 1;
    
    for i = 1:10
        newSize = mean12Months;  %the final size of the adjacencyMatrix
        idCentroids = (1:size(adjacencyMatrix, 1))';
        while size(idCentroids, 1) > newSize
            centroidToDelete = randi(size(idCentroids, 1), 1);
            idCentroids(centroidToDelete) = [];
        end
        
        nameFile = strsplit(files3Months(indexFile).name(11:end), 'It');
        save(strcat('results\randomRemoval\Image', nameFile{1}, '_Random' ,num2str(i), '_12Months'), 'idCentroids');
        
    end
    
    for i = 1:10
        newSize = mean18Months;  %the final size of the adjacencyMatrix
        idCentroids = (1:size(adjacencyMatrix, 1))';
        while size(idCentroids, 1) > newSize
            centroidToDelete = randi(size(idCentroids, 1), 1);
            idCentroids(centroidToDelete) = [];
        end
        
        nameFile = strsplit(files3Months(indexFile).name(11:end), 'It');
        save(strcat('results\randomRemoval\Image', nameFile{1}, '_Random' ,num2str(i), '_18Months'), 'idCentroids');
        
    end
    
end


