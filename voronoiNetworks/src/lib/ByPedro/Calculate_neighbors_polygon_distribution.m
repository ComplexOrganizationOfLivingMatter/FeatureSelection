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
            fullPathFile
            image = imread(fullPathFile);
            image = im2bw(image(:,:,1), 0.2);
            if sum(image(:) == 255) > sum(image(:) == 0) || sum(image(:) == 1) > sum(image(:) == 0)
                Img_L = bwlabel(image);
            else
                image = image == 0;
                Img_L = bwlabel(image);
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
            
            nameWithoutExtension = strsplit(diagramName, '.');
            outputFile = strcat(strjoin(fullPathSplitted(1:end-2), '\'), '\data\', nameWithoutExtension{1}, '_data.mat');
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
            
            %-- OMM files (eye) --%
%             borderCells = [1, neighbours{1}'];
%             allCells = 1:max(Img_L(:));
%             noBorderCells = ismember(allCells, borderCells);
%             noBorderCells = allCells(noBorderCells == 0);
            %--Not OMM (eye) files --%
            for cell=2:max(Img_L(:))
                if unique(Img_det_bord(Img_L == cell))~=1
                    noBorderCells = [noBorderCells, cell];
                else
                    borderCells = [borderCells, cell];
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
            
            vecinos = neighbours;
            celulas_validas = validCells;
            save(outputFile, 'vecinos', 'celulas_validas');
        end
    end
end
