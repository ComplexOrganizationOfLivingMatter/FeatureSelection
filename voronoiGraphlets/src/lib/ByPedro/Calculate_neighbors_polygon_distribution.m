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
        if (size(strfind(lower(diagramName), '.png'), 1) >= 1 || size(strfind(lower(diagramName), '.bmp'), 1) >= 1 || size(strfind(lower(diagramName), '.jpg'), 1) >= 1)
            
            nameWithoutExtension = strsplit(diagramName, '.');
            if isempty(strfind(fullPathFile, 'Weighted'))
                outputFile = strcat(strjoin(fullPathSplitted(1:end-2), '\'), '\data\', nameWithoutExtension{1}, '_data.mat');
            else
                outputFile = strcat(strjoin(fullPathSplitted(1:end-4), '\'), '\data\', strjoin(fullPathSplitted(end-2:end-1), '\'), '\' ,nameWithoutExtension{1}, '_data.mat');
            end
            if exist(outputFile, 'file') ~= 2
                fullPathFile
                numIncorrectAreas = 0;
                borderIncorrect = 0;
                image = imread(fullPathFile);
                image = im2bw(image(:,:,1), 0.2);
                if sum(image(:) == 255) > sum(image(:) == 0) || sum(image(:) == 1) > sum(image(:) == 0)
                    Img_L = bwlabel(image);
                else
                    image = image == 0;
                    Img_L = bwlabel(image);
                end

                areas = regionprops(Img_L, 'Area');
                areas = [areas.Area];
                areasMean = mean(areas);
                incorrectAreas = areas > areasMean*50;
                if sum(incorrectAreas)> 0
                    disp('There are some incorrect cell areas. Trying to autofix it...')
                    [zerosXs, zerosYs] = find(image == 0);
                    image(min(zerosXs), min(zerosYs):max(zerosYs)) = 0;
                    image(min(zerosXs):max(zerosXs), min(zerosYs)) = 0;
                    image(max(zerosXs), min(zerosYs):max(zerosYs)) = 0;
                    image(min(zerosXs):max(zerosXs), max(zerosYs)) = 0;
                    Img_L = bwlabel(image);
                    areas = regionprops(Img_L, 'Area');
                    areas = [areas.Area];
                    areasMean = mean(areas);
                    incorrectAreas = areas > areasMean*50;
                    numIncorrectAreas = find(incorrectAreas);
                    if sum(incorrectAreas)> 0
                        borderIncorrect = 1;
                    end
                end

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


                %load(outputFile);

                %Removing borderCells
                H = size(image, 1);
                W = size(image, 2);
                Img_det_bord=bwlabel(image,8);
                Img_det_bord(1,1:W)=1;
                Img_det_bord(H,1:W)=1;
                Img_det_bord(1:H,1)=1;
                Img_det_bord(1:H,W)=1;
                Img_det_bord = bwlabel(Img_det_bord,8);
                borderCells=[];
                noBorderCells=[];

                %-- files with a white frame (not cells at that frame) --%
                if borderIncorrect
                    borderCells = [numIncorrectAreas, cat(1, neighbours{numIncorrectAreas})'];
                    allCells = 1:max(Img_L(:));
                    noBorderCells = ismember(allCells, borderCells);
                    noBorderCells = allCells(noBorderCells == 0);
                else
                   %-- files with cells partial images at boundaries --%
                    for cell=2:max(Img_L(:))
                        if unique(Img_det_bord(Img_L == cell))~=1
                            noBorderCells = [noBorderCells, cell];
                        else
                            borderCells = [borderCells, cell];
                        end
                    end
                end

                % Removing cells isolated from the valid cells
                noValidCells = unique(borderCells);
                validCells = unique(noBorderCells);

                if size(validCells, 1) == 0
                    error('No valid cells!');
                end
                vecinos = neighbours;
                celulas_validas = validCells;
                save(outputFile, 'vecinos', 'celulas_validas');
            end
        end
    end
end
