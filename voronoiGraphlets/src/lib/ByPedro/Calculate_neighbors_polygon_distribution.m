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
                correct = 0; %If it is a voronoi diagrama, we select which diagrams we want to do
                
                diagramNameToCompare = strrep(diagramName, 'Voronoi_', 'Diagrama_');
                if isempty(strfind(diagramNameToCompare, 'Diagrama_')) == 0
                    for i = 1:9
                        if isempty(strfind(diagramNameToCompare, strcat('Diagrama_00', num2str(i)))) == 0
                            correct = 1;
                            break
                        end
                    end
                    if correct == 0
                        for i = 10:19
                            if isempty(strfind(diagramNameToCompare, strcat('Diagrama_0', num2str(i)))) == 0
                                correct = 1;
                                break
                            end
                        end
                    end
                    if correct == 0
                        for i = 20:10:99
                            if isempty(strfind(diagramNameToCompare, strcat('Diagrama_0', num2str(i)))) == 0
                                correct = 1;
                                break
                            end
                        end
                    end
                    if correct == 0
                        for j = 100:100:700
                            if isempty(strfind(diagramNameToCompare, strcat('Diagrama_', num2str(j)))) == 0
                                correct = 1;
                                break
                            end
                        end
                    end
                else %Not a voronoi diagram
                    correct = 1;
                end
                if correct
                    fullPathFile
                    numIncorrectAreas = 0;
                    borderIncorrect = 0;
                    image = imread(fullPathFile);
                    image = im2bw(image(:,:,1), 0.2);
                    if sum(image(:) == 255) > sum(image(:) == 0) || sum(image(:) == 1) > sum(image(:) == 0)
                        Img_L = watershed(1 - image, 8);
                    else
                        image = image == 0;
                        Img_L = watershed(1 - image, 8);
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
                        Img_L = watershed(1 - image, 8);
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
                    Img_det_bord=watershed(1 - image,8);
                    [zerosXs, zerosYs] = find(Img_det_bord == 0);
                    Img_det_bord(min(zerosXs), min(zerosYs):max(zerosYs))=1;
                    Img_det_bord(max(zerosXs), min(zerosYs):max(zerosYs))=1;
                    Img_det_bord(min(zerosXs):max(zerosXs), min(zerosYs))=1;
                    Img_det_bord(min(zerosXs):max(zerosXs), max(zerosYs))=1;
                    Img_det_bord = watershed(1-Img_det_bord,8);
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
                    vecinos_real = neighbours;

                    celulas_validas_previa = validCells;
                    celulas_no_validas_previa = noValidCells;
                    flag = 0;
                    for j=1:length(celulas_validas_previa) % Bucle que recorre todas celulas validas para comprobar
                        j;
                        vec_cel_ind_j=vecinos_real{celulas_validas_previa(j)};
                        no_coincidencia=[];
                        for x=1:length(vec_cel_ind_j)% Bucle que recorre todos los vecinos de la celula bajo estudio
                            no_coincidencia(x)=isempty(find(vec_cel_ind_j(x)==celulas_no_validas_previa)); %Variable que vale 1 si no existe coincidencia de la celula j con alguna de las celulas no validas
                        end
                        if sum(no_coincidencia)==0
                            validCells=validCells(validCells~=celulas_validas_previa(j));
                            noValidCells=sort([celulas_validas_previa(j),celulas_no_validas_previa]);
                            flag=1;
                        end
                    end
                    if (flag==0)
                        validCells=celulas_validas_previa;                                        %%VARIABLE A GUARDAR
                        noValidCells=celulas_no_validas_previa;
                    end

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
end
