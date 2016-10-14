%This file has the function of calculate the neighbors for each cell in
%every image

function Calculate_neighbors_polygon_distribution(currentPath)

    dataFiles = getAllFiles(currentPath);
    for numFile = 1:size(dataFiles,1)
        fullPathFile = dataFiles(numFile);
        fullPathFile = fullPathFile{:};
        fullPathSplitted = strsplit(fullPathFile, '\');
        diagramName = fullPathSplitted(end);
        diagramName = diagramName{1};

        %Check which files we want.
        if size(strfind(lower(diagramName), '.png'), 1) >= 1
            
            ratio=4;
            se = strel('disk',ratio);
            cells=sort(unique(Img_L));
            cells=cells(2:end);                  %% Deleting cell 0 from range
            neighbours = {};
            for cel = 1:max(Img_L(:))
                BW = bwperim(Img_L==cel);
                [pi,pj]=find(BW==1);

                BW_dilate = imdilate(BW,se);
                pixels_neighs = BW_dilate==1;
                neighs = unique(Img_L(pixels_neighs));
                neighbours{cel} = neighs(neighs ~= 0 & neighs ~= cel);
            end
            
            nameWithoutExtension = strsplit(diagramName, '.');
            outputFile = strcat(fullPathSplited(1:end-2),'\data\' ,nameWithoutExtension, '.mat');
            load(outputFile);
            
            vecinos = neighbours;
            save(outputFile, 'vecinos', 'celulas_validas');
        end
    end
end
